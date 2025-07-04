package org.angelreyes.model;

/**
 *
 * @author Angel Geovanny
 */
public class Persona {

    private String nombrePersona, apellidoPersona, correoPersona, carnetPersona, fotoPersona,
            grado, seccion, grupoAcademico, jornada, carrera;
    private int idPersona,tarjeta;

    public Persona(int idPersona, String nombrePersona, String apellidoPersona, String correoPersona, String carnetPersona, String grado, String seccion, String grupoAcademico, String jornada, String carrera, int tarjeta, String fotoPersona) {
        this.idPersona = idPersona;
        this.nombrePersona = nombrePersona;
        this.apellidoPersona = apellidoPersona;
        this.correoPersona = correoPersona;
        this.carnetPersona = carnetPersona;
        this.grado = grado;
        this.seccion = seccion;
        this.grupoAcademico = grupoAcademico;
        this.jornada = jornada;
        this.carrera = carrera;
        this.tarjeta = tarjeta;
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

    public String getFotoPersona() {
        return fotoPersona;
    }

    public void setFotoPersona(String fotoPersona) {
        this.fotoPersona = fotoPersona;
    }

    public String getGrado() {
        return grado;
    }

    public void setGrado(String grado) {
        this.grado = grado;
    }

    public String getSeccion() {
        return seccion;
    }

    public void setSeccion(String seccion) {
        this.seccion = seccion;
    }

    public String getGrupoAcademico() {
        return grupoAcademico;
    }

    public void setGrupoAcademico(String grupoAcademico) {
        this.grupoAcademico = grupoAcademico;
    }

    public String getJornada() {
        return jornada;
    }

    public void setJornada(String jornada) {
        this.jornada = jornada;
    }

    public String getCarrera() {
        return carrera;
    }

    public void setCarrera(String carrera) {
        this.carrera = carrera;
    }

    public int getTarjeta() {
        return tarjeta;
    }

    public void setTarjeta(int tarjeta) {
        this.tarjeta = tarjeta;
    }

    public int getIdPersona() {
        return idPersona;
    }

    public void setIdPersona(int idPersona) {
        this.idPersona = idPersona;
    }

}
