drop database if exists DBAsistencia;
create database DBAsistencia;
use DBAsistencia;

create table Persona (
	idPersona int not null ,
    nombrePersona varchar(255),
    apellidoPersona varchar(255),
    correoPersona varchar(255),
    carnetPersona varchar(64),
    fotoPersona blob,
    constraint pk_Persona primary key (idPersona)
);

create table Asistencia (
	idAsistencia int not null,
    fecha_hora datetime,
    idPersona int not null ,
    constraint pk_Asistencia primary key (idAsistencia),
    constraint fk_Asistencia_Persona foreign key (idPersona)
		references Persona(idPersona)
);

delimiter //
	create procedure sp_agregarPersona(
    in p_id int,
    in p_nombre varchar(255),
    in p_apellido varchar(255),
    in p_correo varchar(255),
    in p_carnet varchar(64),
    in p_imagen blob)
		begin
			insert into Persona (idPersona, nombrePersona, apellidoPersona, correoPersona, carnetPersona, imagen)
				values (p_id, p_nombre, p_apellido, p_correo, p_carnet, p_imagen);
		end
//delimiter ;
call sp_agregarPersona(1,'Angel Geovanny','Reyes Lopez','areyes@gmail.com','2024435','');
call sp_agregarPersona(2,'Carlos Andrés','Martínez Díaz','carlosm@gmail.com','2024436',);
call sp_agregarPersona(3,'Luisa Fernanda','Gómez Rivera','luisag@gmail.com','2024437',);
call sp_agregarPersona(4,'José Antonio','Pérez Sánchez','josep@gmail.com','2024438',);
call sp_agregarPersona(5,'María Isabel','López Torres','mariai@gmail.com','2024439',);
call sp_agregarPersona(6,'Pedro David','Jiménez Castro','pedroj@gmail.com','2024440',);
call sp_agregarPersona(7,'Ana Patricia','Ramírez Fernández','anap@gmail.com','2024441',);
call sp_agregarPersona(8,'Julián Andrés','Morales López','juliana@gmail.com','2024442',);
call sp_agregarPersona(9,'Silvia Carolina','Ortiz Díaz','silviac@gmail.com','2024443',);
call sp_agregarPersona(10,'Ricardo Javier','Navas Cruz','ricardoj@gmail.com','2024444',);

delimiter //
	create procedure sp_listarPersona()
		begin
			select 
            P.idPersona, 
            P.nombrePersona, 
            P.apellidoPersona, P.correoPersona, 
            P.carnetPersona
            from Persona P;
        end
//delimiter ;
call sp_listarPersona();

-- drop procedure sp_agregarasistencia;
delimiter //
	create procedure sp_agregarAsistencia(
	in p_idasistencia int,
	in p_idpersona int)
		begin
			insert into asistencia (idasistencia, fecha_hora, idpersona)
			values (p_idasistencia, now(), p_idpersona);
		end
//delimiter ;
call sp_agregarAsistencia(1,1);
call sp_agregarAsistencia(2,2);
call sp_agregarAsistencia(3,3);

-- drop procedure sp_listarAsistencia;
delimiter //
	create procedure sp_listarAsistencia()
		begin
			select A.idAsistencia,
				   A.fecha_hora,
				   P.nombrePersona,
				   P.apellidoPersona,
                   P.carnetPersona
			from Asistencia A
				inner join Persona P
    on a.idPersona = p.idPersona;
        end
//delimiter ;
call sp_listarAsistencia();

