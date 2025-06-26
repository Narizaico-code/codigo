package org.angelreyes.controller;

import java.net.URL;
import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalTime;
import java.util.ResourceBundle;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.Label;
import javafx.scene.control.MenuButton;
import javafx.scene.control.MenuItem;
import javafx.scene.control.TableColumn;
import javafx.scene.control.cell.PropertyValueFactory;
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
    @FXML private MenuButton mbCarnet;
    @FXML private MenuItem miUno, miDos, miTres, miCuatro;
    private ObservableList<Ingreso> listarIngresos = FXCollections.observableArrayList();
    @FXML
    private Label lbNombre, lbApellido, lbCarnet, lbEntrada, lbSalida;
    @FXML
    private TableColumn colNombre, colApellido, colCarnet, colEntrada, colIdAsistencia, colIdPersona;
    private Main principal;

    public void setPrincipal(Main principal) {
        this.principal = principal;
    }

    @Override
    public void initialize(URL url, ResourceBundle rb) {
        configurarColumnas();
    }

    public void configurarColumnas() {
        colNombre.setCellValueFactory(new PropertyValueFactory<Persona, Integer>("nombrePersona"));
        colApellido.setCellValueFactory(new PropertyValueFactory<Persona, String>("apellidoPersona"));
        colCarnet.setCellValueFactory(new PropertyValueFactory<Persona, String>("carnetPersona"));
        colEntrada.setCellValueFactory(new PropertyValueFactory<Ingreso, LocalTime>("fecha_hora"));
        colIdAsistencia.setCellValueFactory(new PropertyValueFactory<Ingreso, Integer>("idAsistencia"));
        colIdPersona.setCellValueFactory(new PropertyValueFactory<Ingreso, Integer>("idPersona"));
    }

//    public void cargarDatosPersona(){
//        ObservableList<Persona> listarPersonas = FXCollections.observableArrayList();
//        try (CallableStatement enunciado = Conexion.getInstancia().getConexion().prepareCall("{call sp_listarPersona");
//             ResultSet resultado = enunciado.executeQuery()) {
//            while (resultado.next()){
//                listarPersonas.add(new Persona(
//                        resultado.getInt(1),
//                        resultado.getString(2),
//                        resultado.getString(3),
//                        resultado.getString(4),
//                        resultado.getString(5)));
//            }
//        } catch (SQLException e) {
//            JOptionPane.showMessageDialog(null, "Error al cargar personas: " + e.getMessage(), "Error de Carga", JOptionPane.ERROR_MESSAGE);
//            System.err.println("Error al listar personas: " + e.getMessage());
//            e.printStackTrace();
//        }
//    }
    public void cargarDatos() {
        try (CallableStatement enunciado = Conexion.getInstancia().getConexion().prepareCall("{call sp_listarAsistencia"); ResultSet resultado = enunciado.executeQuery()) {
            while (resultado.next()) {
                ingreso = new Ingreso(
                        resultado.getInt(1),
                        resultado.getInt(2),
                        resultado.getTime(3).toLocalTime(),
                        resultado.getTime(4).toLocalTime(),
                        resultado.getString(5),
                        resultado.getString(6),
                        resultado.getString(7));
            }
        } catch (SQLException e) {
            JOptionPane.showMessageDialog(null, "Error al cargar asistencia: " + e.getMessage(), "Error de Carga", JOptionPane.ERROR_MESSAGE);
            System.err.println("Error al listar personas: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public void cargarLabels() {
        lbNombre.setText(ingreso.getNombrePersona());
        lbApellido.setText(ingreso.getApellidoPersona());
        lbCarnet.setText(ingreso.getCarnetPersona());
        lbEntrada.setText(ingreso.getHoraEntrada().toString());
        lbSalida.setText(ingreso.getHoraSalida().toString()); 
    }
    
    public void activarDesactivarLabels(boolean label){
        lbNombre.setDisable(label);
        lbApellido.setDisable(label);
        lbCarnet.setDisable(label);
        lbEntrada.setDisable(label);
        lbSalida.setDisable(label);
    }
    
    @FXML
    private void lanzarCarnet(){
        if(ev)
    }
}
