drop database if exists DBAsistencia;
create database DBAsistencia;
use DBAsistencia;

create table Persona (
    idPersona int primary key,
    carnetPersona varchar(64),
    nombrePersona varchar(255),
    apellidoPersona varchar(255),
    correoPersona varchar(128),
    grado varchar(50),
    seccion varchar(50),
    grupoAcademico varchar(100),
    jornada varchar(50),
    carrera varchar(100),
    tarjeta int,
    fotoPersona varchar(128)
);

create table Asistencia (
	idAsistencia int not null,
    horaEntrada datetime,
    horaSalida datetime,
    idPersona int  not null ,
    constraint  pk_Asistencia primary key (idAsistencia),
    constraint  fk_Asistencia_Persona foreign key (idPersona)
		references Persona(idPersona)
);
/*call sp_listarPersona();*/
drop procedure if exists sp_agregarPersona;
delimiter //

create procedure sp_agregarPersona(
    in p_idPersona int,
    in p_nombre varchar(255),
    in p_apellido varchar(255),
    in p_correo varchar(128),
    in p_carnet varchar(64),
    in p_grado varchar(50),
    in p_seccion varchar(50),
    in p_grupoAcademico varchar(100),
    in p_jornada varchar(50),
    in p_carrera varchar(100),
    in p_tarjeta int,
    in p_foto varchar(128)
)
begin
    insert into Persona (idPersona, carnetPersona, nombrePersona, apellidoPersona,correoPersona,
        grado, seccion, grupoAcademico, jornada, carrera, tarjeta, fotoPersona
    )
    values (p_idPersona, p_carnet, p_nombre, p_apellido,p_correo,
		p_grado, p_seccion, p_grupoAcademico, p_jornada,
        p_carrera, p_tarjeta, p_foto
    );
end //

delimiter ;


drop procedure if exists sp_ActualizarPersona;
delimiter //

create procedure sp_ActualizarPersona(
    in p_idPersona int,
    in p_nombre      varchar(255),
    in p_apellido    varchar(255),
    in p_correo      varchar(128),
    in p_carnet      varchar(64),
    in p_grado       varchar(50),
    in p_seccion     varchar(50),
    in p_grupoAcademico varchar(100),
    in p_jornada     varchar(50),
    in p_carrera     varchar(100),
    in p_tarjeta     int,
    in p_foto        varchar(128)
)
begin
    update Persona
    set 
        carnetPersona = p_carnet,
        nombrePersona = p_nombre,
        apellidoPersona = p_apellido,
        grado = p_grado,
        seccion = p_seccion,
        grupoAcademico = p_grupoAcademico,
        jornada = p_jornada,
        carrera = p_carrera,
        tarjeta = p_tarjeta,
        fotoPersona = p_foto
    where idPersona = p_idPersona;
end //

delimiter ;


DELIMITER //

create procedure sp_EliminarPersona(
    in p_idPersona int
)
begin
    delete Persona
    from Persona 
    where idPersona = p_idPersona;
end //

DELIMITER ;

call sp_agregarPersona(12345,'Angel Geovanny','Reyes Lopez','areyes-2024435@kinal.edu.gt','2024435','5to','in5CV','PE5CV','JV','informatica',7267027,'/org/angelreyes/images/foto1/2024435.jpg');
/*call sp_agregarPersona('Carlos Andrés','Martínez Díaz','carlosm@gmail.com','2024436',);
call sp_agregarPersona('Luisa Fernanda','Gómez Rivera','luisag@gmail.com','2024437',);
call sp_agregarPersona('José Antonio','Pérez Sánchez','josep@gmail.com','2024438',);
call sp_agregarPersona('María Isabel','López Torres','mariai@gmail.com','2024439',);
call sp_agregarPersona('Pedro David','Jiménez Castro','pedroj@gmail.com','2024440',);
call sp_agregarPersona('Ana Patricia','Ramírez Fernández','anap@gmail.com','2024441',);
call sp_agregarPersona('Julián Andrés','Morales López','juliana@gmail.com','2024442',);
call sp_agregarPersona('Silvia Carolina','Ortiz Díaz','silviac@gmail.com','2024443',);
call sp_agregarPersona('Ricardo Javier','Navas Cruz','ricardoj@gmail.com','2024444',);*/

drop procedure if exists sp_listarPersona;
delimiter //

create procedure sp_listarPersona()
begin
    select 
        idPersona,
        nombrePersona,
        apellidoPersona,
        correoPersona,
        carnetPersona,
        grado,
        seccion,
        grupoAcademico,
        jornada,
        carrera,
        tarjeta,
        fotoPersona
    from Persona;
end //

delimiter ;


-- drop procedure sp_agregarasistencia;
delimiter //
	create procedure sp_agregarAsistencia(
	in p_idasistencia int ,
	in p_idpersona int )
		begin
			insert into asistencia (idasistencia, horaEntrada,horaSalida, idpersona)
			values (p_idasistencia, now(),null, p_idpersona);
		end//
	create procedure sp_marcarSalida(
	in p_idpersona int)
		begin
		  update Asistencia
			set horaSalida = now()
			where idPersona = p_idpersona
			  and horaSalida is null
			order by horaEntrada desc
			limit 1;
		end//
        delimiter ;

call sp_agregarAsistencia(1,12345);
/*call sp_agregarAsistencia(2,1);
call sp_agregarAsistencia(3,1);*/

-- drop procedure sp_listarAsistencia;
delimiter //
	create procedure sp_listarAsistencia()
		begin
			select A.idAsistencia,
				   P.idPersona,
				   A.horaEntrada,
                   A.horaSalida,
				   P.nombrePersona,
				   P.apellidoPersona,
                   P.carnetPersona,
                   P.fotoPersona
			from Asistencia A
				inner join Persona P
    on a.idPersona = p.idPersona;
        end
//delimiter ;

delimiter //

create procedure sp_ActualizarAsistencia(
    in p_idAsistencia int,
    in p_horaEntrada datetime,
    in p_horaSalida datetime,
    in p_idPersona int
)
begin
    update Asistencia
    set 
        horaEntrada = p_horaEntrada,
        horaSalida = p_horaSalida,
        idPersona = p_idPersona
    where idAsistencia = p_idAsistencia;
END //
delimiter ;

delimiter //
create procedure sp_eliminarAsistencia(
    in p_idAsistencia int
)
begin
    delete from Asistencia 
    where idAsistencia = p_idAsistencia;
end //


drop procedure if exists sp_buscarPersonaPorId;
delimiter //

create procedure sp_buscarPersonaPorId(in p_tarjeta int)
begin
    select
        idPersona,
        nombrePersona,
        apellidoPersona,
        correoPersona,
        carnetPersona,
        grado,
        seccion,
        grupoAcademico,
        jornada,
        carrera,
        tarjeta,
        fotoPersona
    from Persona
    where tarjeta = p_tarjeta
    limit 1;
end //
delimiter ;

call sp_listarAsistencia();
delimiter //
create procedure sp_listarAsistenciaPorPersona(in p_tarjeta int)
	begin
		select * from Asistencia A
        left join Persona P on A.idPersona = P.idPersona
		where tarjeta = p_tarjeta
		order by horaEntrada desc
		limit 1;
	end //
delimiter ;

call sp_listarPersona();


/*LOAD DATA LOCAL inFILE 'C:tarjetas.csv'
intO TABLE Persona
FIELDS TERMinATED BY ',' 
ENCLOSED BY '"'
LinES TERMinATED BY '\n'
IGNORE 1 ROWS
(
    idPersona,
    carnetPersona,
    nombrePersona,
    apellidoPersona,
    grado,
    seccion,
    grupoAcademico,
    jornada,
    carrera,
    tarjeta,
    fotoPersona
);
*/