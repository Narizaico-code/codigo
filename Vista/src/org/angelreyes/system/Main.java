package org.angelreyes.system;

import java.io.InputStream;
import javafx.application.Application;
import static javafx.application.Application.launch;
import javafx.application.HostServices;
import javafx.fxml.FXMLLoader;
import javafx.fxml.Initializable;
import javafx.fxml.JavaFXBuilderFactory;
import javafx.scene.Scene;
import javafx.scene.image.Image;
import javafx.stage.Stage;
import org.angelreyes.controller.AsistenciaController;
import org.angelreyes.controller.AñadirController;
import org.angelreyes.controller.IngresoController;
import org.angelreyes.controller.MenuController;

/**
 *
 * @author Angel Geovanny
 */
public class Main extends Application {
    private static HostServices hostServices;
    private static String URL = "/org/angelreyes/view/";
    private Stage escenarioPrincipal;
    private Scene siguienteEscena;

    public static void main(String[] args) {
        launch(args);
    }

    @Override
    public void start(Stage stage) throws Exception {
        hostServices = getHostServices();
        this.escenarioPrincipal = stage;
        stage.getIcons().add(new Image(getClass().getResourceAsStream("/org/angelreyes/images/logo.png")));

        stage.setTitle("Kinal");
        getMenuPrincipalView();
        stage.show();
    }

    public Initializable cambiarEscena(String fxml, double ancho, double alto) throws Exception {
        Initializable interfazDeCambio = null;
        FXMLLoader cargadorFXML = new FXMLLoader();
        InputStream archivoFXML = Main.class.getResourceAsStream(URL + fxml);

        cargadorFXML.setBuilderFactory(new JavaFXBuilderFactory());
        cargadorFXML.setLocation(Main.class.getResource(URL + fxml));

        siguienteEscena = new Scene(cargadorFXML.load(archivoFXML), ancho, alto);
        escenarioPrincipal.setScene(siguienteEscena);
        escenarioPrincipal.sizeToScene();

        interfazDeCambio = cargadorFXML.getController();
        return interfazDeCambio;
    }
    
    public static HostServices getAppHostServices() {
        return hostServices;
    }

    public void getMenuPrincipalView() {
        try {
            MenuController control = (MenuController) cambiarEscena("VistaMenu.fxml", 1000, 900);
            control.setPrincipal(this);
        } catch (Exception ex) {
            System.out.println("Error al ir al Menú Principal: " + ex.getMessage());
            ex.printStackTrace();
        }
    }

    public void getIngresoView() {
        try {
            IngresoController control = (IngresoController) cambiarEscena("VistaIngreso.fxml", 1000, 900);
            control.setPrincipal(this);
        } catch (Exception e) {
            System.out.println("Error al ir al Ingreso: " + e.getMessage());
            e.printStackTrace();
        }
    }

    public void getAñadirView() {
        try {
            AñadirController control = (AñadirController) cambiarEscena("VistaAñadir.fxml", 1000, 900);
            control.setPrincipal(this);
        } catch (Exception e) {
            System.out.println("Error al ir a Añadir: " + e.getMessage());
            e.printStackTrace();
        }
    }
    public void getAsistenciaView() {
        try {
            AsistenciaController control = (AsistenciaController) cambiarEscena("AsistenciaView.fxml", 1000, 900);
            control.setPrincipal(this);
        } catch (Exception e) {
            System.out.println("Error al ir a Añadir: " + e.getMessage());
            e.printStackTrace();
        }
    }
}
