drop database if exists DBAsistencia;
create database DBAsistencia;
use DBAsistencia;

create table Persona (
	idPersona int not null auto_increment,
    nombrePersona varchar(255),
    apellidoPersona varchar(255),
    correoPersona varchar(255),
    carnetPersona varchar(64),
    fotoPersona mediumblob,
	constraint pk_Persona primary key (idPersona)
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

delimiter //
	create procedure sp_agregarPersona(
    in p_nombre varchar(255),
    in p_apellido varchar(255),
    in p_correo varchar(255),
    in p_carnet varchar(64),
    in p_imagen mediumblob)
		begin
			insert into Persona (nombrePersona, apellidoPersona, correoPersona, carnetPersona, fotoPersona)
				values (p_nombre, p_apellido, p_correo, p_carnet, p_imagen);
		end
//delimiter ;

delimiter //

create procedure sp_ActualizarPersona(
    in p_idPersona int ,
    in p_nombrePersona varchar(255),
    in p_apellidoPersona varchar(255),
    in p_correoPersona varchar(255),
    in p_carnetPersona varchar(64),
    in p_fotoPersona mediumblob
)
begin
    update Persona P
    set 
        P.nombrePersona = p_nombrePersona,
        P.apellidoPersona = p_apellidoPersona,
        P.correoPersona = p_correoPersona,
        P.carnetPersona = p_carnetPersona,
        P.fotoPersona = p_fotoPersona
    where P.idPersona = p_idPersona;
end //
delimiter ;

DELIMITER //

create procedure sp_EliminarPersona(
    in p_idPersona int
)
begin
    
    delete Persona
    from Asistencia 
    where idPersona = p_idPersona;
END //

DELIMITER ;

call sp_agregarPersona('Angel Geovanny','Reyes Lopez','areyes@gmail.com','2024435','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');
call sp_agregarPersona('Carlos Andrés','Martínez Díaz','carlosm@gmail.com','2024436',);
call sp_agregarPersona('Luisa Fernanda','Gómez Rivera','luisag@gmail.com','2024437',);
call sp_agregarPersona('José Antonio','Pérez Sánchez','josep@gmail.com','2024438',);
call sp_agregarPersona('María Isabel','López Torres','mariai@gmail.com','2024439',);
call sp_agregarPersona('Pedro David','Jiménez Castro','pedroj@gmail.com','2024440',);
call sp_agregarPersona('Ana Patricia','Ramírez Fernández','anap@gmail.com','2024441',);
call sp_agregarPersona('Julián Andrés','Morales López','juliana@gmail.com','2024442',);
call sp_agregarPersona('Silvia Carolina','Ortiz Díaz','silviac@gmail.com','2024443',);
call sp_agregarPersona('Ricardo Javier','Navas Cruz','ricardoj@gmail.com','2024444',);

delimiter //
	create procedure sp_listarPersona()
		begin
			select 
            P.idPersona, 
            P.nombrePersona, 
            P.apellidoPersona, 
            P.correoPersona, 
            P.carnetPersona,
            P.fotoPersona
            from Persona P;
        end
//delimiter ;
call sp_listarPersona();

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
		end
//
        delimiter ;

call sp_agregarAsistencia(1,1);
call sp_agregarAsistencia(2,1);
call sp_agregarAsistencia(3,1);

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
delimiter ;
delimiter //
create procedure sp_buscarPersonaPorCarnet(in p_carnet varchar(64))
begin
    select
        idPersona, nombrePersona, apellidoPersona,
        correoPersona, carnetPersona, fotoPersona
    from Persona
    where carnetPersona = p_carnet
    limit 1;
end//
delimiter ;
call sp_listarAsistencia();