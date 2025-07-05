
package org.angelreyes.controller;

import java.net.URL;
import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.ResourceBundle;
import javafx.collections.*;
import javafx.event.ActionEvent;
import javafx.fxml.FXML;
import javafx.fxml.Initializable;
import javafx.scene.control.*;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.scene.input.KeyEvent;
import org.angelreyes.database.Conexion;
import org.angelreyes.model.Asistencia;
import org.angelreyes.model.Persona;
import org.angelreyes.system.Main;

/**
 * FXML Controller class
 *
 * @author edy14
 */
public class AsistenciaController implements Initializable {
    
    @FXML private TableView<Asistencia> tablaAsistencia; 
    @FXML private TableColumn<Asistencia, Integer> colIdAsistencia;
    @FXML private TableColumn<Asistencia, String> colHoraEntrada;
    @FXML private TableColumn<Asistencia, String> colHoraSalida;
    @FXML private TableColumn<Asistencia, Integer> colIdPersona;
    @FXML private TableColumn<Asistencia, String> colNombre;
    @FXML private TableColumn<Asistencia, String> colApellido;
    @FXML private TableColumn<Asistencia, String> colCorreo;
    @FXML private TableColumn<Asistencia, String> colCarnet; 
    @FXML private DatePicker dpFechaFiltro;
    @FXML private SplitMenuButton smbFiltro;
    @FXML private TextField txtNombre ;

    @FXML private SplitMenuButton btnFiltrar;
    private String criterioFiltro = "nombre"; // valor por defecto
    private enum FiltroActivo {
        NINGUNO, FECHA, NOMBRE 
    }

    private FiltroActivo filtroActivo = FiltroActivo.NINGUNO;

    private ObservableList<Asistencia> listaAsistencia;
    
    private Main principal;
    
    public void setPrincipal(Main principal) {
            this.principal = principal;
    }
    
    @Override
    public void initialize(URL url, ResourceBundle rb) {
        configurarColumnas();
        cargarDatos();
        
        txtNombre.setOnKeyReleased(e -> actualizarBusqueda());
        dpFechaFiltro.setOnKeyReleased(e -> actualizarBusqueda());
        filtrar(); 
    }

    private void configurarColumnas() {
        colIdAsistencia.setCellValueFactory(new PropertyValueFactory<>("idAsistencia"));
        colHoraEntrada.setCellValueFactory(new PropertyValueFactory<>("horaEntrada"));
        colHoraSalida.setCellValueFactory(new PropertyValueFactory<>("horaSalida"));
        colIdPersona.setCellValueFactory(new PropertyValueFactory<>("idPersona"));
        colNombre.setCellValueFactory(new PropertyValueFactory<>("nombrePersona"));
        colApellido.setCellValueFactory(new PropertyValueFactory<>("apellidoPersona"));
        colCorreo.setCellValueFactory(new PropertyValueFactory<>("correoPersona"));
        colCarnet.setCellValueFactory(new PropertyValueFactory<>("Carnet"));
    }

    private void cargarDatos() {
        listaAsistencia = FXCollections.observableArrayList(listarAsistencias());
        tablaAsistencia.setItems(listaAsistencia);
    }

    private ArrayList<Asistencia> listarAsistencias() {
        ArrayList<Asistencia> lista = new ArrayList<>();
        try {
            CallableStatement cs = Conexion.getInstancia().getConexion().prepareCall("{Call sp_listarAsistencia()}");
            ResultSet rs = cs.executeQuery();
            while (rs.next()) {
                lista.add(new Asistencia(
                     rs.getInt("idAsistencia"),
                    rs.getString("horaEntrada"),
                    rs.getString("horaSalida"),
                    rs.getInt("idPersona"),
                    rs.getString("nombrePersona"),
                    rs.getString("apellidoPersona"),
                    rs.getString("correoPersona"),
                    rs.getString("carnetPersona")
                ));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return lista;
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
    
    private void filtrar(){
        txtNombre.setVisible(false);
        dpFechaFiltro.setVisible(false);
    }
    
    private void limpiartextField(){
        txtNombre.clear();
    }
    
    @FXML private void actualizarBusquedaNombre(){
        actualizarBusqueda();
    }
    
    @FXML private void actualizarBusquedaFecha(){
        actualizarBusqueda();
    }
    
    @FXML
    private void enterPresionado(KeyEvent event) {
        if (event.getCode().toString().equals("ENTER")) {
            actualizarBusqueda();
        }
    }
    
    @FXML
    private void filtrarPorSeleccion() {
        actualizarBusqueda();
    }
  
    @FXML
    private void activarFiltroFecha() {
    filtroActivo = FiltroActivo.FECHA;
    smbFiltro.setText("Filtrar por: Fecha");
        filtrar();
    dpFechaFiltro.setVisible(true);  // Siempre visible
    dpFechaFiltro.setValue(null);
    limpiartextField();
    actualizarBusqueda();
    }
    
    @FXML
    private void filtrarPorNombre() {
    filtroActivo = FiltroActivo.NOMBRE; // o el valor correspondiente para filtro por texto
    criterioFiltro = "nombre";
    smbFiltro.setText("Filtrar por: Nombre & fecha");
    
    filtrar();
    dpFechaFiltro.setVisible(true);
    txtNombre.setVisible(true);
    
    txtNombre.clear();
    actualizarBusqueda();
    }

    @FXML private void actualizarBusqueda() {
    
    String nombres = txtNombre.getText().trim().toLowerCase();
    LocalDate fechas = dpFechaFiltro.getValue(); 
    
    ObservableList<Asistencia>resultados = FXCollections.observableArrayList();
    
    
            for (Asistencia a : listaAsistencia) {
                boolean coincide = true; 
                if (fechas != null && !a.getHoraEntrada().startsWith(fechas.toString())) {
                    coincide = false;
                }
                
                if (!nombres.isEmpty() && !a.getNombrePersona().toLowerCase().contains(nombres)) {
                    coincide = false;
                }
                
                if (coincide) {
                    resultados.add(a);
                }
            }
        tablaAsistencia.setItems(resultados);
}

    // Métodos existentes que se llaman arriba:
        private void buscarPorFecha() {
            LocalDate fecha = dpFechaFiltro.getValue();
            if (fecha != null) {
                ObservableList<Asistencia> resultados = FXCollections.observableArrayList();
                for (Asistencia a : listaAsistencia) {
                    if (a.getHoraEntrada().startsWith(fecha.toString())) {
                        resultados.add(a);
                    }
                }
                tablaAsistencia.setItems(resultados);
            }
        }

    private void buscarPorNombre() {
    filtroActivo = FiltroActivo.NOMBRE;
    criterioFiltro = "nombre";
    smbFiltro.setText("Filtrar por: Nombre");

    
    dpFechaFiltro.setVisible(false); 

    
    dpFechaFiltro.setValue(null);
    
    txtNombre.setVisible(true);
    
    tablaAsistencia.setItems(listaAsistencia); 
    actualizarBusqueda();
    }
    
       public void btnRegresarAccion(ActionEvent evento) {
        principal.getMenuPrincipalView();
    }
 
}
    
