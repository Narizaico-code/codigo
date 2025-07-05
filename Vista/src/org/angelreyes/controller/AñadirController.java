package org.angelreyes.controller;

//java.io
import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.io.InputStream;

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
    private TextField txtNombre, txtApellido, txtCarnet, txtCorreo, txtBuscar, txtIdPersona, txtGrado, txtSeccion, txtGrupoAcademico, txtJornada, txtCarrera, txtTarjeta;
    @FXML
    private Label lbIdTexto;
    @FXML
    private TableView tablaPersona;
    @FXML
    private TableColumn colId, colSeccion, colNombre, colApellido, colCarnet, colCorreo;
    @FXML
    private ImageView ivFoto;
    @FXML
    private Button btnBuscar, btnAnterior, btnSiguiente, btnNuevo, btnEliminar, btnEditar;
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
    desactivarCampos(); // ya desactiva los inputs
    gpDatos.setVisible(false); // oculta todo el formulario
    tablaPersona.setOnMouseClicked(eventHandler -> cargarPersonaFormulario());
    ajustarAlturaTabla();

}


    private void activarCampos() {
        gpDatos.setDisable(false);
        lbIdTexto.setDisable(false);
        txtIdPersona.setDisable(false);
        txtCarrera.setDisable(false);
        txtTarjeta.setDisable(false);
    }

    private void desactivarCampos() {
        gpDatos.setDisable(true);
        lbIdTexto.setDisable(true);
        txtIdPersona.setDisable(true);
        txtCarrera.setDisable(true);
        txtTarjeta.setDisable(true);
    }

    public void configurarColumnas() {
        colId.setCellValueFactory(new PropertyValueFactory<Persona, Integer>("idPersona"));
        colNombre.setCellValueFactory(new PropertyValueFactory<Persona, String>("nombrePersona"));
        colApellido.setCellValueFactory(new PropertyValueFactory<Persona, String>("apellidoPersona"));
        colCarnet.setCellValueFactory(new PropertyValueFactory<Persona, String>("carnetPersona"));
        colCorreo.setCellValueFactory(new PropertyValueFactory<Persona, String>("correoPersona"));
        colSeccion.setCellValueFactory(new PropertyValueFactory<Persona, String>("seccion"));
    }

    public void cargarTablaPersonas() {
        listarPersonas = FXCollections.observableArrayList(listarPersona());
        tablaPersona.setItems(listarPersonas);
        if (!listarPersonas.isEmpty()) {
            tablaPersona.getSelectionModel().selectFirst();
            cargarPersonaFormulario();
        } else {
            limpiarFormulario();
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
            txtCarrera.setText(String.valueOf(personaSeleccionada.getCarrera()));
            txtGrado.setText(String.valueOf(personaSeleccionada.getGrado()));
            txtTarjeta.setText(String.valueOf(personaSeleccionada.getTarjeta()));
            txtSeccion.setText(String.valueOf(personaSeleccionada.getSeccion()));
            txtGrupoAcademico.setText(String.valueOf(personaSeleccionada.getGrupoAcademico()));
            txtJornada.setText(String.valueOf(personaSeleccionada.getJornada()));
            InputStream inputs = getClass().getResourceAsStream(personaSeleccionada.getFotoPersona());
            ivFoto.setImage(new Image(inputs));
        } else {
            limpiarFormulario();
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
        String grado = txtGrado.getText();
        String seccion = txtSeccion.getText();
        String grupoAcademico = txtGrupoAcademico.getText();
        String jornada = txtJornada.getText();
        String carrera = txtCarrera.getText();
        int tarjeta = Integer.parseInt(txtTarjeta.getText());
        String foto = "";
        if (ivFoto.getImage() != null && ivFoto.getImage().getUrl() != null) {
            foto = Paths.get(URI.create(ivFoto.getImage().getUrl())).toString();
        }

        if (foto.isEmpty()) {
            foto = "/org/angelreyes/images/foto1/" + txtCarnet.getText() + ".jpg";
        }

        return new Persona(idPersona, nombre, apellido, correo, carnet, grado, seccion, grupoAcademico, jornada, carrera, tarjeta, foto);
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
                        resultado.getString(6),
                        resultado.getString(7),
                        resultado.getString(8),
                        resultado.getString(9),
                        resultado.getString(10),
                        resultado.getInt(11),
                        resultado.getString(12)));
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
        try (CallableStatement enunciado = Conexion.getInstancia().getConexion().prepareCall("{call sp_agregarPersona(?,?,?,?,?,?,?,?,?,?,?,?)}")) {
            enunciado.setInt(1, nuevaPersona.getIdPersona());
            enunciado.setString(2, nuevaPersona.getNombrePersona());
            enunciado.setString(3, nuevaPersona.getApellidoPersona());
            enunciado.setString(4, nuevaPersona.getCorreoPersona());
            enunciado.setString(5, nuevaPersona.getCarnetPersona());
            enunciado.setString(6, nuevaPersona.getGrado());
            enunciado.setString(7, nuevaPersona.getSeccion());
            enunciado.setString(8, nuevaPersona.getGrupoAcademico());
            enunciado.setString(9, nuevaPersona.getJornada());
            enunciado.setString(10, nuevaPersona.getCarrera());
            enunciado.setInt(11, nuevaPersona.getTarjeta());
            enunciado.setString(12, nuevaPersona.getFotoPersona());
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

        try (CallableStatement enunciado = Conexion.getInstancia().getConexion().prepareCall("{call sp_actualizarPersona(?,?,?,?,?,?,?,?,?,?,?,?)}")) {
            enunciado.setInt(1, personaAActualizar.getIdPersona());
            enunciado.setString(2, personaAActualizar.getNombrePersona());
            enunciado.setString(3, personaAActualizar.getApellidoPersona());
            enunciado.setString(4, personaAActualizar.getCorreoPersona());
            enunciado.setString(5, personaAActualizar.getCarnetPersona());
            enunciado.setString(6, personaAActualizar.getGrado());
            enunciado.setString(7, personaAActualizar.getSeccion());
            enunciado.setString(8, personaAActualizar.getGrupoAcademico());
            enunciado.setString(9, personaAActualizar.getJornada());
            enunciado.setString(10, personaAActualizar.getCarrera());
            enunciado.setInt(11, personaAActualizar.getTarjeta());
            enunciado.setString(12, personaAActualizar.getFotoPersona());
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
        txtCarrera.clear();
        txtSeccion.clear();
        txtTarjeta.clear();
        txtGrado.clear();
        txtJornada.clear();
        txtGrupoAcademico.clear();
        ivFoto.setImage(null);
        txtIdPersona.clear();
    }

    public void actualizarEstadoFormulario(EstadoFormulario estado) {
    estadoActual = estado;
    boolean activo = (estado == EstadoFormulario.AGREGAR || estado == EstadoFormulario.EDITAR);

    gpDatos.setDisable(!activo);      // Habilita o desactiva campos
    gpDatos.setVisible(activo);       // Muestra u oculta el formulario

    lbIdTexto.setDisable(!activo);
    txtIdPersona.setDisable(!activo);
    txtCarrera.setDisable(!activo);
    txtTarjeta.setDisable(!activo);

    tablaPersona.setDisable(activo);
    btnBuscar.setDisable(activo);
    txtBuscar.setDisable(activo);
    btnAnterior.setDisable(activo);
    btnSiguiente.setDisable(activo);

    if (estado == EstadoFormulario.EDITAR) {
        txtIdPersona.setDisable(activo);
    }

    btnNuevo.setText(activo ? "Guardar" : "Nuevo");
    btnEliminar.setText(activo ? "Cancelar" : "Eliminar");
    btnEditar.setDisable(activo);
    
    if (estado == EstadoFormulario.NINGUNO) {
    gpDatos.setVisible(false); // se oculta al cancelar o guardar
    ajustarAlturaTabla(); // <-- ¡Importante! Esto se aplica al final para que se ajuste según el nuevo estado
}
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
                ajustarAlturaTabla(); // <-- ¡Importante! Esto se aplica al final para que se ajuste según el nuevo estado

                break;
            case AGREGAR:
                System.out.println("Guardando nueva persona");
                insertarNuevaPersona();
                if (estadoActual == EstadoFormulario.AGREGAR) {
                    actualizarEstadoFormulario(EstadoFormulario.NINGUNO);
                    ajustarAlturaTabla(); // <-- ¡Importante! Esto se aplica al final para que se ajuste según el nuevo estado

                }
                break;
            case EDITAR:
                System.out.println("Guardando edicion persona");
                actualizarPersona();
                if (estadoActual == EstadoFormulario.EDITAR) {
                    actualizarEstadoFormulario(EstadoFormulario.NINGUNO);
                        ajustarAlturaTabla(); // <-- ¡Importante! Esto se aplica al final para que se ajuste según el nuevo estado

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
         ajustarAlturaTabla(); // <-- ¡Importante! Esto se aplica al final para que se ajuste según el nuevo estado

        actualizarEstadoFormulario(EstadoFormulario.EDITAR);
    }

    @FXML
    private void cancelarEliminarPersona() {
        if (estadoActual == EstadoFormulario.NINGUNO) {
            eliminarPersona();
            System.out.println("Acabo de eliminar una persona en la DB");
                ajustarAlturaTabla(); // <-- ¡Importante! Esto se aplica al final para que se ajuste según el nuevo estado

        } else {
            actualizarEstadoFormulario(EstadoFormulario.NINGUNO);
            if (!listarPersonas.isEmpty()) {
                tablaPersona.getSelectionModel().selectFirst();
                cargarPersonaFormulario();
            } else {
                limpiarFormulario();
            }
            
        }
            ajustarAlturaTabla(); // <-- ¡Importante! Esto se aplica al final para que se ajuste según el nuevo estado

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
        return true;
    }
    
    private void ajustarAlturaTabla() {
    if (gpDatos.isVisible()) {
        tablaPersona.setPrefHeight(10); // más pequeña cuando el formulario aparece
    } else {
        tablaPersona.setPrefHeight(500); // más grande cuando el formulario está oculto
    }
}
    
    

}
