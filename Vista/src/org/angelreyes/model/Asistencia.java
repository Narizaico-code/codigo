package org.angelreyes.model;

/**
 *
 * @author edy14
 */
public class Asistencia {
    private int idAsistencia;
    private String horaEntrada;
    private String horaSalida;
    private int idPersona;
    private String nombrePersona;
    private String apellidoPersona;
    private String correoPersona;
    private String Carnet;

    public Asistencia(int idAsistencia, String horaEntrada, String horaSalida, int idPersona) {
        this.idAsistencia = idAsistencia;
        this.horaEntrada = horaEntrada;
        this.horaSalida = horaSalida;
        this.idPersona = idPersona;
    }

    public Asistencia(int idAsistencia, String horaEntrada, String horaSalida, int idPersona, String nombrePersona, String apellidoPersona, String correoPersona, String Carnet) {
        this.idAsistencia = idAsistencia;
        this.horaEntrada = horaEntrada;
        this.horaSalida = horaSalida;
        this.idPersona = idPersona;
        this.nombrePersona = nombrePersona;
        this.apellidoPersona = apellidoPersona;
        this.correoPersona = correoPersona;
        this.Carnet = Carnet;
    }

    public int getIdAsistencia() {
        return idAsistencia;
    }

    public void setIdAsistencia(int idAsistencia) {
        this.idAsistencia = idAsistencia;
    }

    public String getHoraEntrada() {
        return horaEntrada;
    }

    public void setHoraEntrada(String horaEntrada) {
        this.horaEntrada = horaEntrada;
    }

    public String getHoraSalida() {
        return horaSalida;
    }

    public void setHoraSalida(String horaSalida) {
        this.horaSalida = horaSalida;
    }

    public int getIdPersona() {
        return idPersona;
    }

    public void setIdPersona(int idPersona) {
        this.idPersona = idPersona;
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

    public String getCarnet() {
        return Carnet;
    }

    public void setCarnet(String Carnet) {
        this.Carnet = Carnet;
    }
    
    
    

}