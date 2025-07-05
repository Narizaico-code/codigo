package org.angelreyes.database;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * Clase conexion para configurar el acceso a MySQL
 *
 * @author angelreyes
 */
public class Conexion {
    private static Conexion instancia;
    private static final String URL = "jdbc:mysql://127.0.0.1:3306/DBAsistencia?useSSL=false";
    private static final String USER = "SaulSical";
    private static final String PASSWORD = "admin";
    private static final String DRIVER = "com.mysql.jdbc.Driver";
    private Connection conexion;

    private Conexion() {
        conectar();
    }

    public void conectar() {
        try {
            Class.forName(DRIVER);
            conexion = DriverManager.getConnection(URL, USER, PASSWORD);
        } catch (ClassNotFoundException | SQLException ex) {
            ex.printStackTrace();
        }
    }

    public static Conexion getInstancia() {
        if (instancia == null) {
            instancia = new Conexion();
        }
        return instancia;
    }

    public Connection getConexion() {
        try {
            if (conexion == null || conexion.isClosed()) {
                conectar();
            }
        } catch (SQLException e) {
            System.out.println("Error al reconectar: " + e.getMessage());
        }
        return conexion;
    }

    public void cerrarConexion() {
        try {
            if (conexion != null && !conexion.isClosed()) {
                conexion.close();
            }
        } catch (SQLException e) {
            System.out.println("Error al cerrar conexión: " + e.getMessage());
        }
    }
}