package org.angelreyes.controller;

import java.net.URL;
import java.util.ResourceBundle;
import javafx.fxml.Initializable;
import javafx.fxml.FXML;
import javafx.scene.control.Button;
import javafx.event.ActionEvent;
import org.angelreyes.system.Main;

/**
 * FXML Controller class
 *
 * @author Angel Geovanny
 */
public class MenuController implements Initializable {

    public void setPrincipal(Main principal) {
        this.principal = principal;
    }
    private Main principal;

    @FXML
    private Button btnIngreso, btnAñadir, btnAbrirWeb,btnAsistencia;

    /**
     * Initializes the controller class.
     */
    @Override
    public void initialize(URL url, ResourceBundle rb) {
        btnAbrirWeb.setOnAction(evt -> {
            // Abre la URL en el navegador por defecto
            principal.getAppHostServices().showDocument("https://www.kinal.org.gt/");
        });
    }

   @FXML
    public void clickManejadorEventos(ActionEvent evento) {
        if (evento.getSource() == btnIngreso) {
            principal.getIngresoView();
        } else if (evento.getSource() == btnAñadir) {
            principal.getAñadirView();
        } else if (evento.getSource() == btnAsistencia){
            principal.getAsistenciaView();
        }
    }
}

