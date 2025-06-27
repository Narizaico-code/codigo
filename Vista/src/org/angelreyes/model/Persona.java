package org.angelreyes.model;

/**
 *
 * @author Angel Geovanny
 */
public class Persona {

    private String nombrePersona, apellidoPersona, correoPersona, carnetPersona;
    private int idPersona;
    private byte[] fotoPersona;

    public Persona(int idPersona, String nombrePersona, String apellidoPersona, String correoPersona, String carnetPersona, byte[] fotoPersona) {
        this.idPersona = idPersona;
        this.nombrePersona = nombrePersona;
        this.apellidoPersona = apellidoPersona;
        this.correoPersona = correoPersona;
        this.carnetPersona = carnetPersona;
        this.fotoPersona = fotoPersona;
    }

    public String getNombrePersona() {
        return nombrePersona;
    }

    public void setNombrePersona(String nombrePersona) {
        this.nombrePersona = nombrePersona;
    }

    public String getApellidoPersona() {
        return apellidoPersona;
    }

    public void setApellidoPersona(String apellidoPersona) {
        this.apellidoPersona = apellidoPersona;
    }

    public String getCorreoPersona() {
        return correoPersona;
    }

    public void setCorreoPersona(String correoPersona) {
        this.correoPersona = correoPersona;
    }

    public String getCarnetPersona() {
        return carnetPersona;
    }

    public void setCarnetPersona(String carnetPersona) {
        this.carnetPersona = carnetPersona;
    }

    public int getIdPersona() {
        return idPersona;
    }

    public void setIdPersona(int idPersona) {
        this.idPersona = idPersona;
    }

    public byte[] getFotoPersona() {
        return fotoPersona;
    }

    public void setFotoPersona(byte[] fotoPersona) {
        this.fotoPersona = fotoPersona;
    }

}
