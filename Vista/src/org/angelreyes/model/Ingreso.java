package org.angelreyes.model;

import java.time.LocalTime;

/**
 *
 * @author Angel Geovanny
 */
public class Ingreso {

    private int idAsitencia, idPersona;
    private LocalTime horaEntrada, horaSalida;
    private String nombrePersona, apellidoPersona, carnetPersona;

    public Ingreso(int idAsitencia, int idPersona, LocalTime horaEntrada, LocalTime horaSalida) {
        this.idAsitencia = idAsitencia;
        this.idPersona = idPersona;
        this.horaEntrada = horaEntrada;
    }

    public Ingreso(int idAsitencia, int idPersona, LocalTime horaEntrada, LocalTime horaSalida, String nombrePersona, String apellidoPersona, String carnetPersona) {
        this.idAsitencia = idAsitencia;
        this.idPersona = idPersona;
        this.horaEntrada = horaEntrada;
        this.horaSalida = horaSalida;
        this.nombrePersona = nombrePersona;
        this.apellidoPersona = apellidoPersona;
        this.carnetPersona = carnetPersona;
    }

    public int getIdAsitencia() {
        return idAsitencia;
    }

    public void setIdAsitencia(int idAsitencia) {
        this.idAsitencia = idAsitencia;
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

    public LocalTime getHoraEntrada() {
        return horaEntrada;
    }

    public void setHoraEntrada(LocalTime horaEntrada) {
        this.horaEntrada = horaEntrada;
    }

    public LocalTime getHoraSalida() {
        return horaSalida;
    }

    public void setHoraSalida(LocalTime horaSalida) {
        this.horaSalida = horaSalida;
    }

}
