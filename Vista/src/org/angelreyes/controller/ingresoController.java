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
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Base64;
import java.util.ResourceBundle;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Label;
import javafx.scene.control.MenuButton;
import javafx.scene.control.MenuItem;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javax.swing.JOptionPane;
import org.angelreyes.database.Conexion;
import org.angelreyes.model.Ingreso;
import org.angelreyes.model.Persona;
import org.angelreyes.system.Main;

/**
 * FXML Controller class
 *
 * @author Angel Geovanny
 */
public class IngresoController implements Initializable {

    Ingreso ingreso;
    @FXML
    private TableView tablaIngresos;
    @FXML
    private MenuButton mbCarnet;
    @FXML
    private MenuItem miUno, miDos, miTres, miCuatro;
    private ObservableList<Ingreso> listarIngresos = FXCollections.observableArrayList();
    @FXML
    private Label lbNombre, lbApellido, lbCarnet, lbEntrada, lbSalida, lbIdPersona, lbIdAsistencia;
    private Main principal;
    @FXML
    private ImageView ivFoto;

    public void setPrincipal(Main principal) {
        this.principal = principal;
    }

    @Override
    public void initialize(URL url, ResourceBundle rb) {
        miUno.setOnAction(this::lanzarCarnet);
        miDos.setOnAction(this::lanzarCarnet);
        miTres.setOnAction(this::lanzarCarnet);
        miCuatro.setOnAction(this::lanzarCarnet);
    }

    public void cargarTablaPersonas() {
        listarIngresos = FXCollections.observableArrayList(cargarDatos());
        tablaIngresos.setItems(listarIngresos);
        if (!listarIngresos.isEmpty()) {
            tablaIngresos.getSelectionModel().selectFirst();
            cargarIngresoFormulario();
        } else {
            limpiarFormulario();
        }
    }

    public ArrayList<Ingreso> cargarDatos() {
        ArrayList<Ingreso> ingresos = new ArrayList<>();
        try (Connection conexionv = Conexion.getInstancia().getConexion(); CallableStatement enunciado = Conexion.getInstancia().getConexion().prepareCall("{call sp_listarAsistencia"); ResultSet resultado = enunciado.executeQuery()) {
            while (resultado.next()) {
                ingresos.add(new Ingreso(
                        resultado.getInt(1),
                        resultado.getInt(2),
                        resultado.getTimestamp(3).toLocalDateTime(),
                        resultado.getTimestamp(4).toLocalDateTime(),
                        resultado.getString(5),
                        resultado.getString(6),
                        resultado.getString(7),
                        resultado.getBytes(6)));
            }
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error al cargar asistencia: " + e.getMessage(), "Error de Carga", JOptionPane.ERROR_MESSAGE);
            System.err.println("Error al listar personas: " + e.getMessage());
            e.printStackTrace();
        }
        return ingresos;
    }

    private byte[] convertirImagenABase64(File imagen) throws IOException {
        byte[] bytes = Files.readAllBytes(imagen.toPath());
        return bytes;
    }

    private Ingreso cargarModeloIngreso() {
        Ingreso ingreso = null;
        int idPersona = lbIdPersona.getText().isEmpty() ? 0 : Integer.parseInt(lbIdPersona.getText());
        int idAsistencia = lbIdAsistencia.getText().isEmpty() ? 0 : Integer.parseInt(lbIdAsistencia.getText());
        LocalDateTime horaEntrada = LocalDateTime.parse(lbEntrada.getText());
        LocalDateTime horaSalida = LocalDateTime.parse(lbSalida.getText());
        try {
            ingreso = new Ingreso(idAsistencia, idPersona, horaEntrada, horaSalida, lbNombre.getText(), lbApellido.getText(), lbCarnet.getText(), convertirImagenABase64(Paths.get(URI.create(ivFoto.getImage().getUrl())).toFile()));
        } catch (IOException ex) {
            System.out.println("No se pudo cargar el modelo de Ingreso " + ex.getMessage());
        }
        return ingreso;
    }

    public void insertarAsistencia() throws SQLException {
        Ingreso nuevaIngreso = cargarModeloIngreso();
        try (CallableStatement enunciado = Conexion.getInstancia().getConexion().prepareCall("{call sp_añadirAsistencia(?,?)}")) {
            enunciado.setInt(1, nuevaIngreso.getIdAsitencia());
            enunciado.setInt(2, nuevaIngreso.getIdPersona());
            int registroAgregado = enunciado.executeUpdate();
        }
    }

    private Persona buscarPersonaPorCarnet(String carnet) {
        try (Connection conexionv = Conexion.getInstancia().getConexion(); CallableStatement enunciado = conexionv.prepareCall("{call sp_buscarPersonaPorCarnet(?)}")) {
            enunciado.setString(1, carnet);
            ResultSet resultado = enunciado.executeQuery();
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

        } catch (SQLException ex) {
            ex.printStackTrace();
        }
        return null;
    }

    public void cargarIngresoFormulario() {
        Ingreso ingresoSeleccionado = (Ingreso) tablaIngresos.getSelectionModel().getSelectedItem();
        if (ingresoSeleccionado != null) {
            lbNombre.setText(ingreso.getNombrePersona());
            lbApellido.setText(ingreso.getApellidoPersona());
            lbCarnet.setText(ingreso.getCarnetPersona());
            lbEntrada.setText(ingreso.getHoraEntrada().toString());
            lbSalida.setText(ingreso.getHoraSalida().toString());
            ivFoto.setImage(new Image(new ByteArrayInputStream(Base64.getDecoder().decode(ingresoSeleccionado.getFotoPersona()))));
        }
    }

    public void limpiarFormulario() {
        lbNombre.setText(null);
        lbApellido.setText(null);
        lbCarnet.setText(null);
        lbEntrada.setText(null);
        lbSalida.setText(null);
        ivFoto.setImage(null);
    }

    public void activarLabels() {
        lbNombre.setDisable(false);
        lbApellido.setDisable(false);
        lbCarnet.setDisable(false);
        lbEntrada.setDisable(false);
        lbSalida.setDisable(false);
    }

    public void desactivarLabels() {
        lbNombre.setDisable(true);
        lbApellido.setDisable(true);
        lbCarnet.setDisable(true);
        lbEntrada.setDisable(true);
        lbSalida.setDisable(true);
        ivFoto.setImage(null);
    }

    @FXML
    private void lanzarCarnet(ActionEvent evento) {
        MenuItem origen = (MenuItem) evento.getSource();
        String carnetSeleccionado = origen.getText();

        Persona persona = buscarPersonaPorCarnet(carnetSeleccionado);
        if (persona != null) {
            lbNombre.setText(persona.getNombrePersona());
            lbApellido.setText(persona.getApellidoPersona());
            lbCarnet.setText(persona.getCarnetPersona());
            ivFoto.setImage(
                    new Image(new ByteArrayInputStream(persona.getFotoPersona())));
        } else {
            limpiarFormulario();
            System.err.println("No se encontró persona con carnet " + carnetSeleccionado);
        }
        boolean tienePendiente = listarIngresos.stream()
                .anyMatch(i -> i.getIdPersona() == persona.getIdPersona()
                && i.getHoraSalida() == null);

        try (Connection conexion = Conexion.getInstancia().getConexion()) {
            if (!tienePendiente) {
                int nuevoId = generarNuevoIdAsistencia(conexion);
                try (CallableStatement enunciado = conexion.prepareCall("{call sp_agregarAsistencia(?,?)}")) {
                    enunciado.setInt(1, nuevoId);
                    enunciado.setInt(2, persona.getIdPersona());
                    enunciado.executeUpdate();
                }
                lbEntrada.setText(LocalDateTime.now().toString());
                lbSalida.setText("");
            } else {
                try (CallableStatement enunciado = conexion.prepareCall("{call sp_marcarSalida(?)}")) {
                    enunciado.setInt(1, persona.getIdPersona());
                    enunciado.executeUpdate();
                }
                lbSalida.setText(LocalDateTime.now().toString());
            }
        } catch (SQLException ex) {
            JOptionPane.showMessageDialog(null,
                    "Error al registrar asistencia: " + ex.getMessage(),
                    "Error de BD", JOptionPane.ERROR_MESSAGE);
        }
        
        cargarTablaPersonas();
    }
    
    private int generarNuevoIdAsistencia(Connection conexion) throws SQLException {
    try (Statement enunciado = conexion.createStatement();
         ResultSet resultado = enunciado.executeQuery("select ifnull(max(idAsistencia),0)+1 from Asistencia")) {
        resultado.next();
        return resultado.getInt(1);
    }
}
}
