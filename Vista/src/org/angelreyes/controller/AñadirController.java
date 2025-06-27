package org.angelreyes.controller;

import java.io.File;
import java.net.URL;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.Date;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.ResourceBundle;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.TextField;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.image.ImageView;
import javafx.scene.layout.GridPane;
import javax.swing.JOptionPane;
import org.angelreyes.database.Conexion;
import org.angelreyes.model.Persona;
import org.angelreyes.system.Main;

/**
 * FXML Controller class
 *
 * @author Angel Geovanny
 */
public class AñadirController implements Initializable {

    private Main principal;
    @FXML
    private GridPane gpDatos;
    @FXML
    private TextField txtNombre, txtApellido, txtCarnet, txtCorreo;
    @FXML
    private Label lbId,lbIdTexto;
    @FXML
    private TableView tablaPersona;
    @FXML 
    private TableColumn colId, colNombre, colApellido, colCarnet, colCorreo;
    @FXML
    private ImageView imageView;
    @FXML
    private Button btnCargarImagen;
    private File imagenSeleccionada;
    private ObservableList<Persona> listarPersonas = FXCollections.observableArrayList();

    private enum EstadoFormulario {
        AGREGAR, EDITAR, ELIMINAR, NINGUNO
    }
    EstadoFormulario estadoActual = EstadoFormulario.NINGUNO;

    public void setPrincipal(Main principal) {
        this.principal = principal;
    }

    @Override
    public void initialize(URL url, ResourceBundle rb) {

    }
    private void desactivarCampos() {
        gpDatos.setVisible(false);
        btnCargarImagen.setVisible(false);
        lbIdTexto.setVisible(false);
        lbId.setVisible(false);
    }
    public void configurarColumnas(){
        colId.setCellValueFactory(new PropertyValueFactory<Persona,Integer>("idPersona"));
        colNombre.setCellValueFactory(new PropertyValueFactory<Persona,String>("nombrePersona"));
        colApellido.setCellValueFactory(new PropertyValueFactory<Persona,String>("apellidoPersona"));
        colCarnet.setCellValueFactory(new PropertyValueFactory<Persona,String>("carnetPersona"));
        colCorreo.setCellValueFactory(new PropertyValueFactory<Persona,String>("correoPersona"));
    }
    
    public void cargarTablaPersonas(){
        listarPersonas = FXCollections.observableArrayList(listarPersona());
        tablaPersona.setItems(listarPersonas);
        if (!listarPersonas.isEmpty()) { // Only select first if list is not empty
            tablaPersona.getSelectionModel().selectFirst();
            cargarPersonaFormulario();
        } else {
            limpiarFormulario(); // Clear form if table is empty
        }
    }
    private void cargarPersonaFormulario(){
        Persona personaSeleccionada = (Persona) tablaPersona.getSelectionModel().getSelectedItem();
        if (personaSeleccionada != null) {
            lbId.setText(String.valueOf(personaSeleccionada.getIdPersona()));
            txtNombre.setText(String.valueOf(personaSeleccionada.getNombrePersona()));
            txtApellido.setText(String.valueOf(personaSeleccionada.getApellidoPersona()));
            txtCarnet.setText(String.valueOf(personaSeleccionada.getCarnetPersona()));
            txtCorreo.setText(String.valueOf(personaSeleccionada.getCorreoPersona()));
        } else {
            limpiarFormulario(); // Clear form if no selection
        }
    }
    public ArrayList<Persona> listarPersona(){
        ArrayList<Persona> personas = new ArrayList<>();
        try (Connection conexionv = Conexion.getInstancia().getConexion();
             Statement enunciado = conexionv.createStatement();
             ResultSet resultado = enunciado.executeQuery("{call sp_listarPersona()}")) {
            while (resultado.next()) {
                personas.add(new Persona(
                        resultado.getInt(1),
                        resultado.getString(2),
                        resultado.getString(3),
                        resultado.getString(4),
                        resultado.getString(5)));
            }
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error al cargar personas: " + e.getMessage(), "Error de Carga", JOptionPane.ERROR_MESSAGE);
            System.err.println("Error al cargar personas: " + e.getMessage());
        }
        return personas;
    }
    private Persona cargarModeloPersona(){
        int idPersona = lbId.getText().isEmpty() ? 0 : Integer.parseInt(lbId.getText());
        return new Persona(idPersona, txtNombre.getText(),txtApellido.getText(),txtCorreo.getText(),txtCarnet.getText());
    }
    @FXML
    private void btnSiguienteAccion(){
        int indice = tablaPersona.getSelectionModel().getSelectedIndex();
        if (!listarPersonas.isEmpty() && indice < listarPersonas.size()-1) {
            tablaPersona.getSelectionModel().select(indice+1);
            cargarPersonaFormulario();
        } else if (!listarPersonas.isEmpty() && indice == listarPersonas.size() - 1){ // Loop to beginning
            tablaPersona.getSelectionModel().selectFirst();
            cargarPersonaFormulario();
        }
    }

    @FXML
    private void btnAnteriorAccion(){
        int indice = tablaPersona.getSelectionModel().getSelectedIndex();
        if (!listarPersonas.isEmpty() && indice > 0) {
            tablaPersona.getSelectionModel().select(indice-1);
            cargarPersonaFormulario();
        } else if (!listarPersonas.isEmpty() && indice == 0){ // Loop to end
            tablaPersona.getSelectionModel().selectLast();
            cargarPersonaFormulario();
        }
    }
    
    public void btnRegresarAccion(ActionEvent evento){
        principal.getMenuPrincipalView();
    }
    
    private void insertarNuevaFactura(){
        if (!validarCampos()) { // Validate fields before proceeding
            return;
        }
        Factura nuevaFactura = cargarModeloFactura();

        try (CallableStatement enunciado = Conexion.getInstancia().getConexion().prepareCall("{call sp_agregarFactura(?,?,?,?,?)}")) {
            enunciado.setInt(1, nuevaFactura.getCodigoCliente());
            enunciado.setInt(2, nuevaFactura.getCodigoEmpleado());
            enunciado.setDate(3,Date.valueOf( nuevaFactura.getFechaEmision()));
            enunciado.setDouble(4, nuevaFactura.getTotal());
            enunciado.setString(5, nuevaFactura.getMetodoPago());
            int registroAgregado = enunciado.executeUpdate();
            if (registroAgregado > 0) {
                cargarTablaFacturas();
                JOptionPane.showMessageDialog(null, "Factura agregada correctamente", "Éxito", JOptionPane.INFORMATION_MESSAGE);
            } else {
                JOptionPane.showMessageDialog(null, "La factura no se pudo agregar. No se realizaron cambios.", "Advertencia", JOptionPane.WARNING_MESSAGE);
            }
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error al agregar una nueva factura: " + e.getMessage(), "Error de Base de Datos", JOptionPane.ERROR_MESSAGE);
            System.err.println("Error al agregar una nueva factura: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private boolean validarCampos() {
        // --- Validación para todos los campos vacíos ---
        boolean allFieldsEmpty = (lbId.getText() == null &&
                                  txtNombre.getText() == null &&
                                  txtApellido.getText() == null &&
                                  txtCorreo.getText() == null &&
                                  txtCarnet.getText() == null);

        if (allFieldsEmpty) {
            JOptionPane.showMessageDialog(null, "¡ALERTA! Por favor, complete todos los campos obligatorios.", "Campos Vacíos", JOptionPane.WARNING_MESSAGE);
            return false;
        }

        if (txtNombre.getText() == null) {
            JOptionPane.showMessageDialog(null, "Debe de rellenar el nombre.", "Campo Vacío", JOptionPane.WARNING_MESSAGE);
            return false;
        }
        if (txtApellido.getText() == null) {
            JOptionPane.showMessageDialog(null, "Debe de llenar el campo Apellido.", "Campo Vacío", JOptionPane.WARNING_MESSAGE);
            return false;
        }

        if (txtCorreo.getText() == null) {
            JOptionPane.showMessageDialog(null, "Debe de llenar el campo Correo.", "Campo Vacío", JOptionPane.WARNING_MESSAGE);
            return false;
        }
        if (txtCarnet.getText() == null) {
            JOptionPane.showMessageDialog(null, "Debe de llenar el campo Carnet.", "Campo Vacío", JOptionPane.WARNING_MESSAGE);
            return false;
        }

        return true; // All validations passed
    }
}
