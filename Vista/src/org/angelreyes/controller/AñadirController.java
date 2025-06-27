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
    private TextField txtNombre, txtApellido, txtCarnet, txtCorreo, txtBuscar;
    @FXML
    private Label lbId, lbIdTexto;
    @FXML
    private TableView tablaPersona;
    @FXML
    private TableColumn colId, colNombre, colApellido, colCarnet, colCorreo;
    @FXML
    private ImageView imageView, ivFoto;
    @FXML
    private Button btnCargarImagen,btnBuscar,btnAnterior,btnSiguiente,btnNuevo,btnEliminar,btnEditar;
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
            imageView.setImage(img);
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
        lbId.setDisable(false);
    }

    private void desactivarCampos() {
        gpDatos.setDisable(true);
        btnCargarImagen.setDisable(true);
        lbIdTexto.setDisable(true);
        lbId.setDisable(true);
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
            lbId.setText(String.valueOf(personaSeleccionada.getIdPersona()));
            txtNombre.setText(String.valueOf(personaSeleccionada.getNombrePersona()));
            txtApellido.setText(String.valueOf(personaSeleccionada.getApellidoPersona()));
            txtCarnet.setText(String.valueOf(personaSeleccionada.getCarnetPersona()));
            txtCorreo.setText(String.valueOf(personaSeleccionada.getCorreoPersona()));
            ivFoto.setImage(new Image(new ByteArrayInputStream(Base64.getDecoder().decode(personaSeleccionada.getFotoPersona()))));
        } else {
            limpiarFormulario(); // Clear form if no selection
        }
    }


    private Persona cargarModeloPersona() {
        Persona persona = null;
        int idPersona = lbId.getText().isEmpty() ? 0 : Integer.parseInt(lbId.getText());
        try {
            persona = new Persona(idPersona, txtNombre.getText(), txtApellido.getText(),
                    txtCorreo.getText(), txtCarnet.getText(), convertirImagenABase64(Paths.get(URI.create(ivFoto.getImage().getUrl())).toFile()));
        } catch (IOException ex) {
            System.out.println("No se pudo cargar el modelo: " + ex.getMessage());
            ex.printStackTrace();
        }
        return persona;
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
        if (!validarCampos()) { // Validate fields before proceeding
            return;
        }
        Persona nuevaPersona = cargarModeloPersona();

        try (CallableStatement enunciado = Conexion.getInstancia().getConexion().prepareCall("{call sp_agregarPersona(?,?,?,?,?)}")) {
            enunciado.setString(1, nuevaPersona.getNombrePersona());
            enunciado.setString(2, nuevaPersona.getApellidoPersona());
            enunciado.setString(3, nuevaPersona.getCorreoPersona());
            enunciado.setString(4, nuevaPersona.getCarnetPersona());
            enunciado.setBytes(5, nuevaPersona.getFotoPersona());
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
    
    public void actualizarPersona(){
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
            enunciado.setString(4,personaAActualizar.getCorreoPersona());
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
        lbId.setText(null);
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

        btnNuevo.setText(activo ? "Guardar" : "Nuevo");
        btnEliminar.setText(activo ? "Cancelar" : "Eliminar");
        btnEditar.setDisable(activo);
    }
    
    public void eliminarPersona(){
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
        boolean allFieldsEmpty = (lbId.getText() == null
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
        return true;
    }
}
