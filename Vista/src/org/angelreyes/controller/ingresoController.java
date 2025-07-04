package org.angelreyes.controller;

import java.sql.Statement;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;
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
import java.time.format.DateTimeFormatter;
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

    @FXML
    private TextField txtLeer;
    @FXML
    private Button btnRegresar;
    @FXML
    private Label lbNombre, lbApellido, lbCarnet, lbEntrada, lbSalida, lbIdPersona, lbIdAsistencia;
    @FXML
    private ImageView ivFoto;

    private Main principal;
    private ObservableList<Ingreso> listarIngresos = FXCollections.observableArrayList();

    public void setPrincipal(Main principal) {
        this.principal = principal;
    }

    @Override
    public void initialize(URL url, ResourceBundle rb) {
        Platform.runLater(() -> txtLeer.requestFocus());

        txtLeer.setOnAction(this::procesarCarnet);
    }

    private static final DateTimeFormatter TIME_ONLY
            = DateTimeFormatter.ofPattern("HH:mm:ss");

    @FXML
    private void procesarCarnet(ActionEvent evento) {
        String texto = txtLeer.getText().trim();
        if (texto.isEmpty()) {
            JOptionPane.showMessageDialog(null, "Por favor ingresa un carnet.", "Advertencia", JOptionPane.WARNING_MESSAGE);
            return;
        }
        int idPersona;
        try {
            idPersona = Integer.parseInt(texto);
        } catch (NumberFormatException ex) {
            JOptionPane.showMessageDialog(null, "El carnet debe ser numérico.", "Error", JOptionPane.ERROR_MESSAGE);
            return;
        }

        Persona persona = buscarPersonaPorId(idPersona);
        if (persona == null) {
            limpiarFormulario();
            JOptionPane.showMessageDialog(null,
                    "No se encontró persona con id " + idPersona,
                    "Error", JOptionPane.ERROR_MESSAGE);
            return;
        }
        lbNombre.setText(persona.getNombrePersona());
        lbApellido.setText(persona.getApellidoPersona());
        lbCarnet.setText(persona.getCarnetPersona());
        InputStream inputs = getClass().getResourceAsStream(persona.getFotoPersona());
            ivFoto.setImage(new Image(inputs));
        LocalDateTime ahora = LocalDateTime.now();

        Ingreso ultima = obtenerUltimoIngreso(idPersona);

        try (Connection conexion = Conexion.getInstancia().getConexion()) {
            if (ultima == null || ultima.getHoraSalida() != null) {
                if (ultima != null
                        && Duration.between(ultima.getHoraEntrada(), ahora).toMinutes() < 5) {
                    JOptionPane.showMessageDialog(null,
                            "Ya registraste entrada hace menos de 5 minutos.\nDebes esperar para volver a marcar.",
                            "Aviso", JOptionPane.WARNING_MESSAGE);
                } else {
                    int nuevoId = generarNuevoIdAsistencia(conexion);
                    try (CallableStatement enunciado = conexion.prepareCall("{call sp_agregarAsistencia(?,?)}")) {
                        enunciado.setInt(1, nuevoId);
                        enunciado.setInt(2, idPersona);
                        enunciado.executeUpdate();
                    }
                    lbEntrada.setText(ahora.format(TIME_ONLY));
                    lbSalida.setText("");
                }
            } else {
                long minutos = Duration.between(ultima.getHoraEntrada(), ahora).toMinutes();
                if (minutos < 5) {
                    JOptionPane.showMessageDialog(null,
                            "No han pasado 5 minutos desde la entrada.\nNo puedes marcar la salida aún.",
                            "Aviso", JOptionPane.WARNING_MESSAGE);
                    lbEntrada.setText(ultima.getHoraEntrada().format(TIME_ONLY));
                } else {
                    try (CallableStatement enunciado = conexion.prepareCall("{call sp_marcarSalida(?)}")) {
                        enunciado.setInt(1, idPersona);
                        enunciado.executeUpdate();
                    }
                    lbEntrada.setText(ultima.getHoraEntrada().format(TIME_ONLY));
                    lbSalida.setText(ahora.format(TIME_ONLY));
                }
            }
        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(null,
                    "Error al procesar asistencia: " + ex.getMessage(),
                    "Error BD", JOptionPane.ERROR_MESSAGE);
        }

        txtLeer.clear();
        txtLeer.requestFocus();
    }

    private Ingreso obtenerUltimoIngreso(int idPersona) {
        String sql
                = "{call sp_listarAsistenciaPorPersona(?)}";
        try (Connection conexion = Conexion.getInstancia().getConexion(); CallableStatement enunciado = conexion.prepareCall(sql)) {
            enunciado.setInt(1, idPersona);
            try (ResultSet resultado = enunciado.executeQuery()) {
                if (resultado.next()) {
                    LocalDateTime entrada = resultado.getTimestamp("horaEntrada")
                            .toLocalDateTime();
                    java.sql.Timestamp tsSalida = resultado.getTimestamp("horaSalida");
                    LocalDateTime salida = tsSalida != null
                            ? tsSalida.toLocalDateTime()
                            : null;
                    return new Ingreso(
                            resultado.getInt("idAsistencia"),
                            idPersona,
                            entrada,
                            salida,
                            null,
                            null, null, null
                    );
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    private ArrayList<Ingreso> cargarDatos() {
        ArrayList<Ingreso> ingresos = new ArrayList<>();
        String sql = "{call sp_listarAsistencia()}";

        try (
                Connection conexion = Conexion.getInstancia().getConexion(); CallableStatement enunciado = conexion.prepareCall(sql); ResultSet resultado = enunciado.executeQuery()) {

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
                        resultado.getString(8)
                ));
            }
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null,
                    "Error al cargar asistencia: " + e.getMessage(),
                    "Error de Carga", JOptionPane.ERROR_MESSAGE);
        }

        return ingresos;
    }

    private Persona buscarPersonaPorId(int id) {
        String sql = "{call sp_buscarPersonaPorId(?)}";
        try (Connection conexion = Conexion.getInstancia().getConexion(); CallableStatement enunciado = conexion.prepareCall(sql)) {
            enunciado.setString(1, String.valueOf(id));
            try (ResultSet resultado = enunciado.executeQuery()) {
                if (resultado.next()) {
                    return new Persona(
                            resultado.getInt(1),
                            resultado.getString(2),
                            resultado.getString(3),
                            resultado.getString(4),
                            resultado.getString(5),
                            resultado.getString(6),
                            resultado.getString(7),
                            resultado.getString(8),
                            resultado.getString(9),
                            resultado.getString(10),
                            resultado.getInt(11),
                            resultado.getString(12));
                }
            }
        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    private int generarNuevoIdAsistencia(Connection conexion) throws SQLException {
        try (Statement enunciado = conexion.createStatement(); ResultSet resultado = enunciado.executeQuery(
                "SELECT IFNULL(MAX(idAsistencia),0)+1 FROM Asistencia")) {
            resultado.next();
            return resultado.getInt(1);
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
