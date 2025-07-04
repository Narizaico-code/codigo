package org.angelreyes.model;

import java.time.LocalDateTime;

/**
 *
 * @author Angel Geovanny
 */
public class Ingreso {

    private int idAsistencia, idPersona;
    private LocalDateTime horaEntrada, horaSalida;
    private String nombrePersona, apellidoPersona, carnetPersona;
    private String fotoPersona;

    public Ingreso(LocalDateTime horaEntrada, LocalDateTime horaSalida, String nombrePersona, String apellidoPersona, String carnetPersona) {
        this.horaEntrada = horaEntrada;
        this.horaSalida = horaSalida;
        this.nombrePersona = nombrePersona;
        this.apellidoPersona = apellidoPersona;
        this.carnetPersona = carnetPersona;
    }

    public Ingreso(int idAsitencia, int idPersona,LocalDateTime horaEntrada, LocalDateTime horaSalida, String nombrePersona, String apellidoPersona, String carnetPersona, String fotoPersona) {
        this.idAsistencia = idAsitencia;
        this.idPersona = idPersona;
        this.horaEntrada = horaEntrada;
        this.horaSalida = horaSalida;
        this.nombrePersona = nombrePersona;
        this.apellidoPersona = apellidoPersona;
        this.carnetPersona = carnetPersona;
        this.fotoPersona = fotoPersona;
    }

    public int getIdAsitencia() {
        return idAsistencia;
    }

    public void setIdAsitencia(int idAsitencia) {
        this.idAsistencia = idAsitencia;
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

    public String getCarnetPersona() {
        return carnetPersona;
    }

    public void setCarnetPersona(String carnetPersona) {
        this.carnetPersona = carnetPersona;
    }

    public LocalDateTime getHoraEntrada() {
        return horaEntrada;
    }

    public void setHoraEntrada(LocalDateTime horaEntrada) {
        this.horaEntrada = horaEntrada;
    }

    public LocalDateTime getHoraSalida() {
        return horaSalida;
    }

    public void setHoraSalida(LocalDateTime horaSalida) {
        this.horaSalida = horaSalida;
    }

    public String getFotoPersona() {
        return fotoPersona;
    }

    public void setFotoPersona(String fotoPersona) {
        this.fotoPersona = fotoPersona;
    }

}
