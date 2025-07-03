drop database if exists DBAsistencia;
create database DBAsistencia;
use DBAsistencia;

create table Persona (
	idPersona int not null,
    nombrePersona varchar(255),
    apellidoPersona varchar(255),
    correoPersona varchar(255),
    carnetPersona varchar(64),
    fotoPersona varchar(128),
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
/*call sp_listarPersona();*/
drop procedure if exists sp_agregarPersona;
delimiter //
	create procedure sp_agregarPersona(
    in p_idPersona int,
    in p_nombre varchar(255),
    in p_apellido varchar(255),
    in p_correo varchar(255),
    in p_carnet varchar(64),
    in p_imagen varchar(128))
		begin
			insert into Persona (idPersona,nombrePersona, apellidoPersona, correoPersona, carnetPersona, fotoPersona)
				values (p_idPersona,p_nombre, p_apellido, p_correo, p_carnet, p_imagen);
		end
//delimiter ;

drop procedure if exists sp_ActualizarPersona;
delimiter //
create procedure sp_ActualizarPersona(
    in p_idPersona int,
    in p_nombrePersona varchar(255),
    in p_apellidoPersona varchar(255),
    in p_correoPersona varchar(255),
    in p_carnetPersona varchar(64),
    in p_fotoPersona varchar(128)
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
    from Persona 
    where idPersona = p_idPersona;
end //

DELIMITER ;

call sp_agregarPersona(0007267027,'Angel Geovanny','Reyes Lopez','areyes@gmail.com','2024435','');
/*call sp_agregarPersona('Carlos Andrés','Martínez Díaz','carlosm@gmail.com','2024436',);
call sp_agregarPersona('Luisa Fernanda','Gómez Rivera','luisag@gmail.com','2024437',);
call sp_agregarPersona('José Antonio','Pérez Sánchez','josep@gmail.com','2024438',);
call sp_agregarPersona('María Isabel','López Torres','mariai@gmail.com','2024439',);
call sp_agregarPersona('Pedro David','Jiménez Castro','pedroj@gmail.com','2024440',);
call sp_agregarPersona('Ana Patricia','Ramírez Fernández','anap@gmail.com','2024441',);
call sp_agregarPersona('Julián Andrés','Morales López','juliana@gmail.com','2024442',);
call sp_agregarPersona('Silvia Carolina','Ortiz Díaz','silviac@gmail.com','2024443',);
call sp_agregarPersona('Ricardo Javier','Navas Cruz','ricardoj@gmail.com','2024444',);*/

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
		end//
        delimiter ;

call sp_agregarAsistencia(1,0007267027);
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
delimiter ;
drop procedure if exists sp_buscarPersonaPorId;
delimiter //
create procedure sp_buscarPersonaPorId(in p_idPersona int)
begin
    select
		idPersona,
		nombrePersona, apellidoPersona,
        correoPersona, carnetPersona, fotoPersona
    from Persona
    where p_idPersona = idPersona
    limit 1;
end//
delimiter ;
call sp_listarAsistencia();
delimiter //
create procedure sp_listarAsistenciaPorPersona(in p_idPersona int)
	begin
		select * from Asistencia
		where idPersona = p_idPersona
		order by horaEntrada desc
		limit 1;
	end //
delimiter ;