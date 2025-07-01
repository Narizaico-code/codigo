package org.angelreyes.controller;

import java.sql.Statement;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.net.URI;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.Duration;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Base64;
import java.util.ResourceBundle;
import javafx.application.Platform;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.TableView;
import javafx.scene.control.TextField;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javax.swing.JOptionPane;
import org.angelreyes.database.Conexion;
import org.angelreyes.model.Ingreso;
import org.angelreyes.model.Persona;
import org.angelreyes.system.Main;

public class IngresoController implements Initializable {

    @FXML private TextField txtLeer;
    @FXML private TableView<Ingreso> tablaIngresos;
    @FXML private Button btnRegresar;
    @FXML private Label lbNombre, lbApellido, lbCarnet, lbEntrada, lbSalida, lbIdPersona, lbIdAsistencia;
    @FXML private ImageView ivFoto;

    private Main principal;
    private ObservableList<Ingreso> listarIngresos = FXCollections.observableArrayList();

    public void setPrincipal(Main principal) {
        this.principal = principal;
    }

    @Override
    public void initialize(URL url, ResourceBundle rb) {
        // 1) Pedir foco al campo de lectura
        Platform.runLater(() -> txtLeer.requestFocus());

        // 2) Al pulsar Enter en txtLeer, llamamos a procesarCarnet()
        txtLeer.setOnAction(this::procesarCarnet);

        // 3) Cargamos la tabla al arrancar
        cargarTablaIngresos();
    }

    private void procesarCarnet(ActionEvent evento) {
        int id = Integer.parseInt(txtLeer.getText().trim());
        if (txtLeer.getText().trim().isEmpty()) {
            JOptionPane.showMessageDialog(null, "Por favor ingresa un carnet.", "Advertencia", JOptionPane.WARNING_MESSAGE);
            return;
        }

        Persona persona = buscarPersonaPorId(id);
        if (persona == null) {
            limpiarFormulario();
            JOptionPane.showMessageDialog(null, "No se encontró persona con id de persona " + id, "Error", JOptionPane.ERROR_MESSAGE);
            return;
        }

        // Mostrar datos básicos
        lbNombre.setText(persona.getNombrePersona());
        lbApellido.setText(persona.getApellidoPersona());
        lbCarnet.setText(persona.getCarnetPersona());
        ivFoto.setImage(new Image(new ByteArrayInputStream(persona.getFotoPersona())));

        // Procesar entrada/salida
        LocalDateTime ahora = LocalDateTime.now();

        // Buscar última asistencia de esta persona en la lista cargada
        Ingreso ultima = listarIngresos.stream()
            .filter(i -> i.getIdPersona() == persona.getIdPersona())
            .max((a, b) -> a.getHoraEntrada().compareTo(b.getHoraEntrada()))
            .orElse(null);

        try (Connection conn = Conexion.getInstancia().getConexion()) {
            if (ultima == null || ultima.getHoraSalida() != null) {
                // No hay registro pendiente → marcar entrada
                if (ultima != null && Duration.between(ultima.getHoraEntrada(), ahora).toMinutes() < 5) {
                    JOptionPane.showMessageDialog(null,
                        "Ya registraste entrada hace menos de 5 minutos.\nDebes esperar para volver a marcar.",
                        "Aviso", JOptionPane.WARNING_MESSAGE);
                } else {
                    int nuevoId = generarNuevoIdAsistencia(conn);
                    try (CallableStatement cs = conn.prepareCall("{call sp_agregarAsistencia(?,?)}")) {
                        cs.setInt(1, nuevoId);
                        cs.setInt(2, persona.getIdPersona());
                        cs.executeUpdate();
                    }
                    lbEntrada.setText(ahora.toString());
                    lbSalida.setText("");
                }
            } else {
                // Hay un registro abierto → marcar salida
                long minutosPendientes = Duration.between(ultima.getHoraEntrada(), ahora).toMinutes();
                if (minutosPendientes < 5) {
                    JOptionPane.showMessageDialog(null,
                        "No han pasado 5 minutos desde la entrada.\nNo puedes marcar la salida aún.",
                        "Aviso", JOptionPane.WARNING_MESSAGE);
                } else {
                    try (CallableStatement cs = conn.prepareCall("{call sp_marcarSalida(?)}")) {
                        cs.setInt(1, persona.getIdPersona());
                        cs.executeUpdate();
                    }
                    lbSalida.setText(ahora.toString());
                }
            }
        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(null,
                "Error al procesar asistencia: " + ex.getMessage(),
                "Error BD", JOptionPane.ERROR_MESSAGE);
            ex.printStackTrace();
        }

        // Refrescar tabla y limpiar el campo de lectura
        cargarTablaIngresos();
        txtLeer.clear();
        txtLeer.requestFocus();
    }

    public void cargarTablaIngresos() {
        listarIngresos = FXCollections.observableArrayList(cargarDatos());
        tablaIngresos.setItems(listarIngresos);
        if (!listarIngresos.isEmpty()) {
            tablaIngresos.getSelectionModel().selectFirst();
            cargarIngresoFormulario(listarIngresos.get(0));
        } else {
            limpiarFormulario();
        }
    }

    private ArrayList<Ingreso> cargarDatos() {
        ArrayList<Ingreso> ingresos = new ArrayList<>();
        String sql = "{call sp_listarAsistencia()}";
        try (Connection conn = Conexion.getInstancia().getConexion();
             CallableStatement cs = conn.prepareCall(sql);
             ResultSet resultado = cs.executeQuery()) {

            while (resultado.next()) {
                ingresos.add(new Ingreso(
                    resultado.getInt(1),
                    resultado.getInt(2),
                    resultado.getTimestamp(3).toLocalDateTime(),
                    resultado.getTimestamp(4) != null 
                        ? resultado.getTimestamp(4).toLocalDateTime()
                        : null,
                    resultado.getString(5),
                    resultado.getString(6),
                    resultado.getString(7),
                    resultado.getBytes(8)
                ));
            }
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null,
                "Error al cargar asistencia: " + e.getMessage(),
                "Error de Carga", JOptionPane.ERROR_MESSAGE);
            e.printStackTrace();
        }
        return ingresos;
    }

    private Persona buscarPersonaPorId(int id) {
        String sql = "{call sp_buscarPersonaPorId(?)}";
        try (Connection conexion = Conexion.getInstancia().getConexion();
             CallableStatement enunciado = conexion.prepareCall(sql)) {
            enunciado.setInt(1, id);
            try (ResultSet resultado = enunciado.executeQuery()) {
                if (resultado.next()) {
                    return new Persona(
                        resultado.getInt("idPersona"),
                        resultado.getString("nombrePersona"),
                        resultado.getString("apellidoPersona"),
                        resultado.getString("correoPersona"),
                        resultado.getString("carnetPersona"),
                        resultado.getBytes("fotoPersona")
                    );
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    private int generarNuevoIdAsistencia(Connection conexion) throws SQLException {
        try (Statement stmt = conexion.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT IFNULL(MAX(idAsistencia),0)+1 FROM Asistencia")) {
            rs.next();
            return rs.getInt(1);
        }
    }

    private void cargarIngresoFormulario(Ingreso ingresoSeleccionado) {
        if (ingresoSeleccionado != null) {
            lbNombre.setText(ingresoSeleccionado.getNombrePersona());
            lbApellido.setText(ingresoSeleccionado.getApellidoPersona());
            lbCarnet.setText(ingresoSeleccionado.getCarnetPersona());
            lbEntrada.setText(ingresoSeleccionado.getHoraEntrada().toString());
            lbSalida.setText(
                ingresoSeleccionado.getHoraSalida() != null
                    ? ingresoSeleccionado.getHoraSalida().toString()
                    : ""
            );
            ivFoto.setImage(new Image(
                new ByteArrayInputStream(Base64.getDecoder()
                    .decode(ingresoSeleccionado.getFotoPersona()))
            ));
        }
    }

    private void limpiarFormulario() {
        lbNombre.setText("");
        lbApellido.setText("");
        lbCarnet.setText("");
        lbEntrada.setText("");
        lbSalida.setText("");
        ivFoto.setImage(null);
    }

    @FXML
    private void btnRegresarAccion(ActionEvent evento) {
        principal.getMenuPrincipalView();
    }
}