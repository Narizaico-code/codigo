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
    private Button btnIngreso, btnAñadir;

    /**
     * Initializes the controller class.
     */
    @Override
    public void initialize(URL url, ResourceBundle rb) {

    }

    @FXML
    public void clickManejadorEventos(ActionEvent evento) {
        if (evento.getSource() == btnIngreso) {
            principal.getIngresoView();
        } else if (evento.getSource() == btnAñadir) {
            principal.getAñadirView();
        }
    }
}
