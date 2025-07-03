package org.angelreyes.controller;

//java.io
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;

//java.net
import java.net.URI;
import java.net.URL;

//java.nio
import java.nio.file.Files;
import java.nio.file.Paths;
//java.sql
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
//java.util
import java.util.ArrayList;
import java.util.Base64;
import java.util.ResourceBundle;
//java.collections
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
//java.event
import javafx.event.ActionEvent;
//javafx

import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Button;
import javafx.scene.control.Label;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.TextField;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.image.Image;
import javafx.scene.image.ImageView;
import javafx.scene.layout.GridPane;
import javafx.stage.FileChooser;
//javax
import javax.swing.JOptionPane;
//org
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
    private TextField txtNombre, txtApellido, txtCarnet, txtCorreo, txtBuscar,txtIdPersona;
    @FXML
    private Label lbIdTexto;
    @FXML
    private TableView tablaPersona;
    @FXML
    private TableColumn colId, colNombre, colApellido, colCarnet, colCorreo;
    @FXML
    private ImageView ivFoto;
    @FXML
    private Button btnCargarImagen, btnBuscar, btnAnterior, btnSiguiente, btnNuevo, btnEliminar, btnEditar;
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
        configurarColumnas();
        cargarTablaPersonas();
        desactivarCampos();
        tablaPersona.setOnMouseClicked(eventHandler -> cargarPersonaFormulario());
    }

    @FXML
    private void onCargarImagen(ActionEvent event) {
        FileChooser fileChooser = new FileChooser();
        fileChooser.setTitle("Seleccionar imagen");
        fileChooser.getExtensionFilters().add(
                new FileChooser.ExtensionFilter("Imágenes", "*.png", "*.jpg", "*.jpeg")
        );
        File file = fileChooser.showOpenDialog(btnCargarImagen.getScene().getWindow());
        if (file != null) {
            imagenSeleccionada = file;
            Image img = new Image(file.toURI().toString());
            ivFoto.setImage(img);
        }
    }

    private byte[] convertirImagenABase64(File imagen) throws IOException {
        byte[] bytes = Files.readAllBytes(imagen.toPath());
        return bytes;
    }

    private void activarCampos() {
        gpDatos.setDisable(false);
        btnCargarImagen.setDisable(false);
        lbIdTexto.setDisable(false);
        txtIdPersona.setDisable(false);
    }

    private void desactivarCampos() {
        gpDatos.setDisable(true);
        btnCargarImagen.setDisable(true);
        lbIdTexto.setDisable(true);
        txtIdPersona.setDisable(true);
    }

    public void configurarColumnas() {
        colId.setCellValueFactory(new PropertyValueFactory<Persona, Integer>("idPersona"));
        colNombre.setCellValueFactory(new PropertyValueFactory<Persona, String>("nombrePersona"));
        colApellido.setCellValueFactory(new PropertyValueFactory<Persona, String>("apellidoPersona"));
        colCarnet.setCellValueFactory(new PropertyValueFactory<Persona, String>("carnetPersona"));
        colCorreo.setCellValueFactory(new PropertyValueFactory<Persona, String>("correoPersona"));
    }

    public void cargarTablaPersonas() {
        listarPersonas = FXCollections.observableArrayList(listarPersona());
        tablaPersona.setItems(listarPersonas);
        if (!listarPersonas.isEmpty()) { // Only select first if list is not empty
            tablaPersona.getSelectionModel().selectFirst();
            cargarPersonaFormulario();
        } else {
            limpiarFormulario(); // Clear form if table is empty
        }
    }

    private void cargarPersonaFormulario() {
        Persona personaSeleccionada = (Persona) tablaPersona.getSelectionModel().getSelectedItem();
        if (personaSeleccionada != null) {
            txtIdPersona.setText(String.valueOf(personaSeleccionada.getIdPersona()));
            txtNombre.setText(String.valueOf(personaSeleccionada.getNombrePersona()));
            txtApellido.setText(String.valueOf(personaSeleccionada.getApellidoPersona()));
            txtCarnet.setText(String.valueOf(personaSeleccionada.getCarnetPersona()));
            txtCorreo.setText(String.valueOf(personaSeleccionada.getCorreoPersona()));
            byte[] fotoBytes = personaSeleccionada.getFotoPersona();
            if (fotoBytes != null && fotoBytes.length > 0) {
                ivFoto.setImage(new Image(new ByteArrayInputStream(fotoBytes)));
            } else {
                ivFoto.setImage(null);
            }
        } else {
            limpiarFormulario(); // Clear form if no selection
        }
    }

    private Persona cargarModeloPersona() {
        String textoId = txtIdPersona.getText();
        int idPersona;
        if (textoId == null || textoId.isEmpty()) {
            idPersona = 0;
        } else {
            idPersona = Integer.parseInt(textoId);
        }

        String nombre = txtNombre.getText();
        String apellido = txtApellido.getText();
        String correo = txtCorreo.getText();
        String carnet = txtCarnet.getText();

        byte[] fotoBytes;
        if (imagenSeleccionada == null) {
            String defaultB64 = "iVBORw0KGgoAAAANSUhEUgAAAgAAAAIACAMAAADDpiTIAAAAA3NCSVQICAjb4U/gAAAACXBIWXMAABJpAAASaQGeQmIhAAAAGXRFWHRTb2Z0d2FyZQB3d3cuaW5rc2NhcGUub3Jnm+48GgAAAwBQTFRF////AQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACAQACl5/7/AAAAP90Uk5TAAECAwQF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";
            fotoBytes = Base64.getDecoder().decode(defaultB64);
        } else {
            try {
                fotoBytes = convertirImagenABase64(imagenSeleccionada);
            } catch (IOException ex) {
                ex.printStackTrace();
                fotoBytes = new byte[0];
            }
        }

        return new Persona(idPersona, nombre, apellido, correo, carnet, fotoBytes);
    }

    public ArrayList<Persona> listarPersona() {
        ArrayList<Persona> personas = new ArrayList<>();
        try (Connection conexionv = Conexion.getInstancia().getConexion(); Statement enunciado = conexionv.createStatement(); ResultSet resultado = enunciado.executeQuery("{call sp_listarPersona()}")) {
            while (resultado.next()) {
                personas.add(new Persona(
                        resultado.getInt(1),
                        resultado.getString(2),
                        resultado.getString(3),
                        resultado.getString(4),
                        resultado.getString(5),
                        resultado.getBytes(6)));
            }
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error al cargar personas: " + e.getMessage(), "Error de Carga", JOptionPane.ERROR_MESSAGE);
            System.err.println("Error al cargar personas: " + e.getMessage());
        }
        return personas;
    }

    private void insertarNuevaPersona() {
        if (!validarCampos()) {
            return;
        }
        Persona nuevaPersona = cargarModeloPersona();
        try (CallableStatement enunciado = Conexion.getInstancia().getConexion().prepareCall("{call sp_agregarPersona(?,?,?,?,?,?)}")) {
            enunciado.setInt(1, nuevaPersona.getIdPersona());
            enunciado.setString(2, nuevaPersona.getNombrePersona());
            enunciado.setString(3, nuevaPersona.getApellidoPersona());
            enunciado.setString(4, nuevaPersona.getCorreoPersona());
            enunciado.setString(5, nuevaPersona.getCarnetPersona());
            enunciado.setBytes(6, nuevaPersona.getFotoPersona());
            int registroAgregado = enunciado.executeUpdate();
            if (registroAgregado > 0) {
                cargarTablaPersonas();
                JOptionPane.showMessageDialog(null, "Persona agregada correctamente", "Éxito", JOptionPane.INFORMATION_MESSAGE);
            } else {
                JOptionPane.showMessageDialog(null, "La persona no se pudo agregar. No se realizaron cambios.", "Advertencia", JOptionPane.WARNING_MESSAGE);
            }
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error al agregar una nueva persona: " + e.getMessage(), "Error de Base de Datos", JOptionPane.ERROR_MESSAGE);
            System.err.println("Error al agregar una nueva persona: " + e.getMessage());
            e.printStackTrace();
        }

    }

    public void actualizarPersona() {
        if (!validarCampos()) {
            return;
        }
        Persona personaAActualizar = cargarModeloPersona();
        if (personaAActualizar.getIdPersona() == 0) {
            JOptionPane.showMessageDialog(null, "Debe seleccionar una persona para editar.", "Advertencia", JOptionPane.WARNING_MESSAGE);
            return;
        }

        try (CallableStatement enunciado = Conexion.getInstancia().getConexion().prepareCall("{call sp_actualizarPersona(?, ?, ?, ?, ?, ?)}")) {
            enunciado.setInt(1, personaAActualizar.getIdPersona());
            enunciado.setString(2, personaAActualizar.getNombrePersona());
            enunciado.setString(3, personaAActualizar.getApellidoPersona());
            enunciado.setString(4, personaAActualizar.getCorreoPersona());
            enunciado.setString(5, personaAActualizar.getCarnetPersona());
            enunciado.setBytes(6, personaAActualizar.getFotoPersona());
            int rowsAffected = enunciado.executeUpdate();
            if (rowsAffected > 0) {
                cargarTablaPersonas();
                JOptionPane.showMessageDialog(null, "Persona actualizada correctamente", "Éxito", JOptionPane.INFORMATION_MESSAGE);
            } else {
                JOptionPane.showMessageDialog(null, "La persona no se pudo actualizar. Verifique si el código de la persona existe.", "Advertencia", JOptionPane.WARNING_MESSAGE);
            }
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "No se pudo actualizar correctamente la persona: " + e.getMessage(), "Error de Base de Datos", JOptionPane.ERROR_MESSAGE);
            System.err.println("No se pudo actualizar correctamente: " + e.getMessage());
            e.printStackTrace();
        }
    }

    @FXML
    private void btnSiguienteAccion() {
        int indice = tablaPersona.getSelectionModel().getSelectedIndex();
        if (!listarPersonas.isEmpty() && indice < listarPersonas.size() - 1) {
            tablaPersona.getSelectionModel().select(indice + 1);
            cargarPersonaFormulario();
        } else if (!listarPersonas.isEmpty() && indice == listarPersonas.size() - 1) { // Loop to beginning
            tablaPersona.getSelectionModel().selectFirst();
            cargarPersonaFormulario();
        }
    }

    @FXML
    private void btnAnteriorAccion() {
        int indice = tablaPersona.getSelectionModel().getSelectedIndex();
        if (!listarPersonas.isEmpty() && indice > 0) {
            tablaPersona.getSelectionModel().select(indice - 1);
            cargarPersonaFormulario();
        } else if (!listarPersonas.isEmpty() && indice == 0) { // Loop to end
            tablaPersona.getSelectionModel().selectLast();
            cargarPersonaFormulario();
        }
    }

    public void btnRegresarAccion(ActionEvent evento) {
        principal.getMenuPrincipalView();
    }

    public void limpiarFormulario() {
        txtNombre.clear();
        txtApellido.clear();
        txtCorreo.clear();
        txtCarnet.clear();
        ivFoto.setImage(null);
        txtIdPersona.clear();
    }

    public void actualizarEstadoFormulario(EstadoFormulario estado) {
        estadoActual = estado;
        boolean activo = (estado == EstadoFormulario.AGREGAR || estado == EstadoFormulario.EDITAR);

        if (activo) {
            activarCampos();
        } else {
            desactivarCampos();
        }

        tablaPersona.setDisable(activo);
        btnBuscar.setDisable(activo);
        txtBuscar.setDisable(activo);
        btnAnterior.setDisable(activo);
        btnSiguiente.setDisable(activo);
        if(estado == EstadoFormulario.EDITAR){
            txtIdPersona.setDisable(activo);
        }

        btnNuevo.setText(activo ? "Guardar" : "Nuevo");
        btnEliminar.setText(activo ? "Cancelar" : "Eliminar");
        btnEditar.setDisable(activo);
    }

    public void eliminarPersona() {
        Persona personaAEliminar = (Persona) tablaPersona.getSelectionModel().getSelectedItem();
        if (personaAEliminar == null) {
            JOptionPane.showMessageDialog(null, "Debe seleccionar una persona para eliminar.", "Advertencia", JOptionPane.WARNING_MESSAGE);
            return;
        }

        int confirmResult = JOptionPane.showConfirmDialog(null, "¿Está seguro de que desea eliminar esta persona?", "Confirmar Eliminación", JOptionPane.YES_NO_OPTION);
        if (confirmResult == JOptionPane.YES_OPTION) {
            try (CallableStatement enunciado = Conexion.getInstancia().getConexion().prepareCall("{call sp_eliminarPersona(?)}")) {
                enunciado.setInt(1, personaAEliminar.getIdPersona());
                int rowsAffected = enunciado.executeUpdate();
                if (rowsAffected > 0) {
                    cargarTablaPersonas();
                    JOptionPane.showMessageDialog(null, "Persona eliminada correctamente", "Éxito", JOptionPane.INFORMATION_MESSAGE);
                } else {
                    JOptionPane.showMessageDialog(null, "La persona no se pudo eliminar. No se encontró el registro.", "Advertencia", JOptionPane.WARNING_MESSAGE);
                }
            } catch (SQLException e) {
                JOptionPane.showMessageDialog(null, "Error al eliminar una persona: " + e.getMessage(), "Error de Base de Datos", JOptionPane.ERROR_MESSAGE);
                System.err.println("Error al eliminar una persona: " + e.getMessage());
                e.printStackTrace();
            }
        }
    }

    @FXML
    private void cambiarGuardarPersona() {
        switch (estadoActual) {
            case NINGUNO:
                limpiarFormulario();
                System.out.println("Voy a preparar el formulario");
                actualizarEstadoFormulario(EstadoFormulario.AGREGAR);
                break;
            case AGREGAR:
                System.out.println("Guardando nueva persona");
                insertarNuevaPersona();
                if (estadoActual == EstadoFormulario.AGREGAR) {
                    actualizarEstadoFormulario(EstadoFormulario.NINGUNO);
                }
                break;
            case EDITAR:
                System.out.println("Guardando edicion persona");
                actualizarPersona();
                if (estadoActual == EstadoFormulario.EDITAR) {
                    actualizarEstadoFormulario(EstadoFormulario.NINGUNO);
                }
                break;
            default:
                break;
        }
    }

    @FXML
    private void cambiarEdicionPersona() {
        if (tablaPersona.getSelectionModel().getSelectedItem() == null) {
            JOptionPane.showMessageDialog(null, "Debe seleccionar una persona para editar.", "Advertencia", JOptionPane.WARNING_MESSAGE);
            return;
        }
        actualizarEstadoFormulario(EstadoFormulario.EDITAR);
    }

    @FXML
    private void cancelarEliminarPersona() {
        if (estadoActual == EstadoFormulario.NINGUNO) {
            eliminarPersona();
            System.out.println("Acabo de eliminar una persona en la DB");
        } else {
            actualizarEstadoFormulario(EstadoFormulario.NINGUNO);
            if (!listarPersonas.isEmpty()) {
                tablaPersona.getSelectionModel().selectFirst();
                cargarPersonaFormulario();
            } else {
                limpiarFormulario();
            }
        }
    }

    @FXML
    private void buscarMetodoPersona() {
        String searchText = txtBuscar.getText().trim();

        if (searchText.isEmpty()) {
            JOptionPane.showMessageDialog(null, "Ingrese el carnet de la persona a buscar.", "Advertencia", JOptionPane.WARNING_MESSAGE);
            cargarTablaPersonas();
            return;
        }
        try {
            String carnetPersona = searchText;
            ArrayList<Persona> resultadoBusqueda = new ArrayList<>();
            for (Persona persona : listarPersonas) {
                if (persona.getCarnetPersona().equals(carnetPersona)) {
                    resultadoBusqueda.add(persona);
                    break;
                }
            }

            tablaPersona.setItems(FXCollections.observableArrayList(resultadoBusqueda));
            if (!resultadoBusqueda.isEmpty()) {
                tablaPersona.getSelectionModel().selectFirst();
                cargarPersonaFormulario();
            } else {
                JOptionPane.showMessageDialog(null, "No se encontraron personas con el carnet ingresado.", "Búsqueda", JOptionPane.INFORMATION_MESSAGE);
                limpiarFormulario();
            }
        } catch (NumberFormatException e) {
            JOptionPane.showMessageDialog(null, "Por favor, ingrese un número entero válido para el carnet de la persona.", "Entrada Inválida", JOptionPane.ERROR_MESSAGE);
            txtBuscar.clear();
        }
    }

    private boolean validarCampos() {
        boolean allFieldsEmpty = (txtIdPersona.getText() == null
                && txtNombre.getText() == null
                && txtApellido.getText() == null
                && txtCorreo.getText() == null
                && txtCarnet.getText() == null);

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
        if (ivFoto.getImage() == null) {
            JOptionPane.showMessageDialog(null, "Debe de llenar el campo Imagen.", "Campo Vacío", JOptionPane.WARNING_MESSAGE);
            return false;
        }
        return true;
    }
}
