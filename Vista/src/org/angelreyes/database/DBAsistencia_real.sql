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

/*call sp_agregarPersona(12345,'Angel Geovanny','Reyes Lopez','areyes-2024435@kinal.edu.gt','2024435','5to','in5CV','PE5CV','JV','informatica',7267027,'/org/angelreyes/images/foto1/2024435.jpg');*/
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

delimiter $$
	create procedure sp_agregarPersona2(
    in p_idPersona int,
    in p_carnet varchar(64),
    in p_nombre varchar(255),
    in p_apellido varchar(255),
    in p_grado varchar(50),
    in p_seccion varchar(50),
    in p_grupoAcademico varchar(100),
    in p_jornada varchar(50),
    in p_carrera varchar(100),
    in p_tarjeta int
)
	begin
		insert into Persona (idPersona, carnetPersona, nombrePersona, apellidoPersona,correoPersona,
        grado, seccion, grupoAcademico, jornada, carrera, tarjeta, fotoPersona
    )
    values (p_idPersona, p_carnet, p_nombre, p_apellido,concat(lower(left(p_nombre, 1)),
    lower(substring_index(p_apellido, ' ', 1)),'-',p_carnet,'@kinal.edu.gt'),
		p_grado, p_seccion, p_grupoAcademico, p_jornada,
        p_carrera, p_tarjeta, concat('/org/angelreyes/images/foto1/',p_carnet,'.jpg')
    );
    end $$
delimiter ;
call sp_agregarPersona2(39021,'2023539','Elias Eliseo','Abularach Hernández','Tercero','BA3AM','N/A','JM','Educación Básica','0008025055');
call sp_agregarPersona2(39022,'2023315','Carlos Daniel','Alvarado Murga','Tercero','BA3AM','N/A','JM','Educación Básica','0002744974');
call sp_agregarPersona2(39023,'2023289','Luis Enrique','Armas Alarcón','Tercero','BA3AM','N/A','JM','Educación Básica','0002698280');
call sp_agregarPersona2(39024,'2023366','Juan Rodrigo','Barrientos Lucas','Tercero','BA3AM','N/A','JM','Educación Básica','0002698275');
call sp_agregarPersona2(39025,'2025493','Eduardo Isaí','Chacoj Ixcotoyac','Tercero','BA3AM','N/A','JM','Educación Básica','0002755346');
call sp_agregarPersona2(39026,'2023005','Edwin Josué','Del Cid Aguilar','Tercero','BA3AM','N/A','JM','Educación Básica','0002755341');
call sp_agregarPersona2(39027,'2023596','Roger Emmanuel','Elias Ceballos','Tercero','BA3AM','N/A','JM','Educación Básica','0007311704');
call sp_agregarPersona2(39028,'2023156','Kevin Alexander','Figueroa Rivera','Tercero','BA3AM','N/A','JM','Educación Básica','0002770559');
call sp_agregarPersona2(39029,'2025451','José Ángel Nicolás','González Soto','Tercero','BA3AM','N/A','JM','Educación Básica','0002773297');
call sp_agregarPersona2(39030,'2023549','Ángel Joaquín','Hernández Alvarez','Tercero','BA3AM','N/A','JM','Educación Básica','0002742171');
call sp_agregarPersona2(39031,'2023398','José Esteban','Hernández Tello','Tercero','BA3AM','N/A','JM','Educación Básica','0002742166');
call sp_agregarPersona2(39032,'2023081','Cristopher Isaias','Huaz Poncio','Tercero','BA3AM','N/A','JM','Educación Básica','0002742161');
call sp_agregarPersona2(39033,'2023383','Carlos Alejandro','Marroquín Flores','Tercero','BA3AM','N/A','JM','Educación Básica','0002754154');
call sp_agregarPersona2(39034,'2023230','Saúl Emanuel Leonardo','Martínez Morales','Tercero','BA3AM','N/A','JM','Educación Básica','0002760994');
call sp_agregarPersona2(39035,'2023397','Hector Javier','Martinez Solórzano','Tercero','BA3AM','N/A','JM','Educación Básica','0002760999');
call sp_agregarPersona2(39036,'2023491','Angel Anibal','Minchez Chico','Tercero','BA3AM','N/A','JM','Educación Básica','0002761007');
call sp_agregarPersona2(39037,'2023471','Jorge Pablo','Mus Morales','Tercero','BA3AM','N/A','JM','Educación Básica','0002761002');
call sp_agregarPersona2(39038,'2023055','Luis Pedro','Pablo Cerrato','Tercero','BA3AM','N/A','JM','Educación Básica','0002747486');
call sp_agregarPersona2(39039,'2023155','Angel Sebastian','Peralta Rodas','Tercero','BA3AM','N/A','JM','Educación Básica','0007276667');
call sp_agregarPersona2(39040,'2024072','Angel Antonio','Pérez Zapeta','Tercero','BA3AM','N/A','JM','Educación Básica','0007303912');
call sp_agregarPersona2(39041,'2023299','Julio Enrique','Quixtán López','Tercero','BA3AM','N/A','JM','Educación Básica','0007313877');
call sp_agregarPersona2(39042,'2024260','Abner Daniel','Ramirez Gaitan','Tercero','BA3AM','N/A','JM','Educación Básica','0007289966');
call sp_agregarPersona2(39043,'2023036','Juan Emilio','Reyes Pineda','Tercero','BA3AM','N/A','JM','Educación Básica','0007316310');
call sp_agregarPersona2(39044,'2023130','Jose Gabriel','Rosales Hernández','Tercero','BA3AM','N/A','JM','Educación Básica','0007286407');
call sp_agregarPersona2(39045,'2023202','Anthony Joaquin','Sam Roque','Tercero','BA3AM','N/A','JM','Educación Básica','0007297169');
call sp_agregarPersona2(39046,'2023319','Miguel Antonio','Santizo Coronado','Tercero','BA3AM','N/A','JM','Educación Básica','0007323827');
call sp_agregarPersona2(39047,'2023180','José Alejandro','Tiú Tubac','Tercero','BA3AM','N/A','JM','Educación Básica','0007317945');
call sp_agregarPersona2(39048,'2023348','Pablo Rene','Us Martínez','Tercero','BA3AM','N/A','JM','Educación Básica','0007295216');
call sp_agregarPersona2(39049,'2023387','Jostin Snaider','Velásquez Gonzáles','Tercero','BA3AM','N/A','JM','Educación Básica','0007281378');
call sp_agregarPersona2(39050,'2023320','Diego Alejandro','Yol Castillo','Tercero','BA3AM','N/A','JM','Educación Básica','0007257834');
call sp_agregarPersona2(39051,'2023448','Rodrigo Isaac','Acetun Montufar','Tercero','BA3BM','N/A','JM','Educación Básica','0007284696');
call sp_agregarPersona2(39052,'2022423','Franderson Yoesmer','Aguilón Pérez','Tercero','BA3BM','N/A','JM','Educación Básica','0007292664');
call sp_agregarPersona2(39053,'2023003','Victor Manuel Alejandro','Alvarez Noj','Tercero','BA3BM','N/A','JM','Educación Básica','0004318892');
call sp_agregarPersona2(39054,'2022301','Jose Alfredo','Arreaga Tum','Tercero','BA3BM','N/A','JM','Educación Básica','0004318870');
call sp_agregarPersona2(39055,'2023151','Moisés Benjamín','Barrios Aragón','Tercero','BA3BM','N/A','JM','Educación Básica','0005489698');
call sp_agregarPersona2(39056,'2024229','Jonatan Ismael','Cardona López','Tercero','BA3BM','N/A','JM','Educación Básica','0005489237');
call sp_agregarPersona2(39057,'2023314','José Emilio','Castañeda Mérida','Tercero','BA3BM','N/A','JM','Educación Básica','0007325418');
call sp_agregarPersona2(39058,'2023385','Anderson Gabriel','Coc corado','Tercero','BA3BM','N/A','JM','Educación Básica','0005493246');
call sp_agregarPersona2(39059,'2023328','Justin Steve','Del Valle Cuyùn','Tercero','BA3BM','N/A','JM','Educación Básica','0005196589');
call sp_agregarPersona2(39060,'2023401','Gabriel de Jesús','Escobedo Fuentes','Tercero','BA3BM','N/A','JM','Educación Básica','0007573548');
call sp_agregarPersona2(39061,'2023027','Abraham Fernando','Flores Garrido','Tercero','BA3BM','N/A','JM','Educación Básica','0004986231');
call sp_agregarPersona2(39062,'2023226','Joaquín Gabriel','Garcia Jurado','Tercero','BA3BM','N/A','JM','Educación Básica','0090753704');
call sp_agregarPersona2(39063,'2023590','José Ángel','Gómez Chivalan','Tercero','BA3BM','N/A','JM','Educación Básica','0007249264');
call sp_agregarPersona2(39064,'2023469','Josué Daniel','Gonzalez Villeda','Tercero','BA3BM','N/A','JM','Educación Básica','0007292414');
call sp_agregarPersona2(39065,'2023063','Carlos Enrique','Hernandez Nicolas','Tercero','BA3BM','N/A','JM','Educación Básica','0007301696');
call sp_agregarPersona2(39066,'2023049','Pablo Abdiel','Izquierdo Juárez','Tercero','BA3BM','N/A','JM','Educación Básica','0007246288');
call sp_agregarPersona2(39067,'2023436','Pablo Fernando','Marroquin García','Tercero','BA3BM','N/A','JM','Educación Básica','0005559615');
call sp_agregarPersona2(39068,'2025544','Julián','Mazariegos Rosales','Tercero','BA3BM','N/A','JM','Educación Básica','0005553767');
call sp_agregarPersona2(39069,'2023028','Sergio Estuardo','Meza Jiménez','Tercero','BA3BM','N/A','JM','Educación Básica','0007274301');
call sp_agregarPersona2(39070,'2023575','Germán André','Navarro Rodriguez','Tercero','BA3BM','N/A','JM','Educación Básica','0005500483');
call sp_agregarPersona2(39071,'2023426','Juan José','Paiz Sosa','Tercero','BA3BM','N/A','JM','Educación Básica','0005500490');
call sp_agregarPersona2(39072,'2023033','Javier Alejandro','Pérez Alvarado','Tercero','BA3BM','N/A','JM','Educación Básica','0005500493');
call sp_agregarPersona2(39073,'2023070','Andy Noé','Polanco Quiñonez','Tercero','BA3BM','N/A','JM','Educación Básica','0005500510');
call sp_agregarPersona2(39074,'2023148','José Benjamín','Ramos López','Tercero','BA3BM','N/A','JM','Educación Básica','0005509545');
call sp_agregarPersona2(39075,'2023326','Diego Yovani','Reynoso Linares','Tercero','BA3BM','N/A','JM','Educación Básica','0005509552');
call sp_agregarPersona2(39076,'2023129','Pablo Raúl','Rosales Mejía','Tercero','BA3BM','N/A','JM','Educación Básica','0005509555');
call sp_agregarPersona2(39077,'2023072','Juan José','Sicajau Pascual','Tercero','BA3BM','N/A','JM','Educación Básica','0007317021');
call sp_agregarPersona2(39078,'2023468','Jorge Adrian','Yumán González','Tercero','BA3BM','N/A','JM','Educación Básica','0007325973');
call sp_agregarPersona2(39079,'2023354','Adrian Eduardo','Zuleta Ramáz','Tercero','BA3BM','N/A','JM','Educación Básica','0007278753');
call sp_agregarPersona2(39080,'2023146','Adrián Natanael','Aguilar Cal','Tercero','BA3CM','N/A','JM','Educación Básica','0007276449');
call sp_agregarPersona2(39081,'2023239','Francisco Xavier','Alvarez Ramos','Tercero','BA3CM','N/A','JM','Educación Básica','0007323754');
call sp_agregarPersona2(39082,'2023178','Marcos Adrián','Barillas López','Tercero','BA3CM','N/A','JM','Educación Básica','0007299462');
call sp_agregarPersona2(39083,'2023090','Erick Gabriel','Barrios Véliz','Tercero','BA3CM','N/A','JM','Educación Básica','0007312420');
call sp_agregarPersona2(39084,'2023537','Omar Antonio','Castillo Aburto','Tercero','BA3CM','N/A','JM','Educación Básica','0006615716');
call sp_agregarPersona2(39085,'2025393','David Alexander','Chaj Barrios','Tercero','BA3CM','N/A','JM','Educación Básica','0006611432');
call sp_agregarPersona2(39086,'2023330','Pablo Gerardo','Coj González','Tercero','BA3CM','N/A','JM','Educación Básica','0006840448');
call sp_agregarPersona2(39087,'2023093','Juan Ignacio','Espinoza Duarte','Tercero','BA3CM','N/A','JM','Educación Básica','0005505267');
call sp_agregarPersona2(39088,'2025504','Rodrigo Alexander','Fonseca Córdova','Tercero','BA3CM','N/A','JM','Educación Básica','0007314708');
call sp_agregarPersona2(39089,'2023529','Christian Andree','García Martínez','Tercero','BA3CM','N/A','JM','Educación Básica','0090535129');
call sp_agregarPersona2(39090,'2022082','Moisés Walter Gabriel','García Méndez','Tercero','BA3CM','N/A','JM','Educación Básica','0006812243');
call sp_agregarPersona2(39091,'2023133','Fabricio José','Granados Ramos','Tercero','BA3CM','N/A','JM','Educación Básica','0005627061');
call sp_agregarPersona2(39092,'2023507','Mario David','Hernández Quijano','Tercero','BA3CM','N/A','JM','Educación Básica','0005505287');
call sp_agregarPersona2(39093,'2023449','Juan Esteban','Interiano Riera','Tercero','BA3CM','N/A','JM','Educación Básica','0002453226');
call sp_agregarPersona2(39094,'2023569','Diego Gabriel','Juarez Castellanos','Tercero','BA3CM','N/A','JM','Educación Básica','0005505315');
call sp_agregarPersona2(39095,'2023206','Eduardo André','Marroquin Tánchez','Tercero','BA3CM','N/A','JM','Educación Básica','0005502195');
call sp_agregarPersona2(39096,'2025542','Pablo Andrés','Mazariegos Cosajay','Tercero','BA3CM','N/A','JM','Educación Básica','0006674454');
call sp_agregarPersona2(39097,'2023430','JEFFERSON ALEXSANDER ISAAC','Mazul Juárez','Tercero','BA3CM','N/A','JM','Educación Básica','0006816529');
call sp_agregarPersona2(39098,'2023057','RUSSELL ADRIÁN','ORTIZ VELÁSQUEZ','Tercero','BA3CM','N/A','JM','Educación Básica','0006674500');
call sp_agregarPersona2(39099,'2023259','Kenneth Alejandro','Palencia Samayoa','Tercero','BA3CM','N/A','JM','Educación Básica','0002968019');
call sp_agregarPersona2(39100,'2023350','Antony Sebastian','Perez Liquez','Tercero','BA3CM','N/A','JM','Educación Básica','0010750891');
call sp_agregarPersona2(39101,'2024280','Luis René','Queche López','Tercero','BA3CM','N/A','JM','Educación Básica','0010751064');
call sp_agregarPersona2(39102,'2023008','Santiago Jose','Rodriguez Chajon','Tercero','BA3CM','N/A','JM','Educación Básica','0006953853');
call sp_agregarPersona2(39103,'2023391','Aaron Sebastián','Rubio Molina','Tercero','BA3CM','N/A','JM','Educación Básica','0009626846');
call sp_agregarPersona2(39104,'2023291','Kevin Gabriel','Sian Mancilla','Tercero','BA3CM','N/A','JM','Educación Básica','0006604750');
call sp_agregarPersona2(39105,'2025090','Russell Juan Diego','Sirín Osorio','Tercero','BA3CM','N/A','JM','Educación Básica','0005591582');
call sp_agregarPersona2(39106,'2023425','Josse Miguel','Tzubán Toyom','Tercero','BA3CM','N/A','JM','Educación Básica','0006962643');
call sp_agregarPersona2(39107,'2023321','Randy Estuardo','Velásquez Quiñónez','Tercero','BA3CM','N/A','JM','Educación Básica','0006961568');
call sp_agregarPersona2(39108,'2023140','Byron Alfredo Isaac','Xep Velasquez','Tercero','BA3CM','N/A','JM','Educación Básica','0006965871');
call sp_agregarPersona2(39109,'2023591','Eliu Isaac','Ajú Méndez','Tercero','BA3DM','N/A','JM','Educación Básica','0013700260');
call sp_agregarPersona2(39110,'2024518','Rolando Diego Alexander','Albizures Tiul','Tercero','BA3DM','N/A','JM','Educación Básica','0001668241');
call sp_agregarPersona2(39111,'2023534','Andrés Edoardo','Aquino López','Tercero','BA3DM','N/A','JM','Educación Básica','0001675068');
call sp_agregarPersona2(39112,'2023585','Emiliano Javier','Barillas Velasquez','Tercero','BA3DM','N/A','JM','Educación Básica','0010034361');
call sp_agregarPersona2(39113,'2023481','David Alejandro','Beteta Ayerdi','Tercero','BA3DM','N/A','JM','Educación Básica','0005510395');
call sp_agregarPersona2(39114,'2022177','Dereck Andrés','Castillo Moctezuma','Tercero','BA3DM','N/A','JM','Educación Básica','0007910542');
call sp_agregarPersona2(39115,'2023544','Julian Andre','Dìaz Lopez','Tercero','BA3DM','N/A','JM','Educación Básica','0001683974');
call sp_agregarPersona2(39116,'2023463','Alexis Enrique','Diéguez Sánchez','Tercero','BA3DM','N/A','JM','Educación Básica','0001660856');
call sp_agregarPersona2(39117,'2023394','Angel David','Estrada López','Tercero','BA3DM','N/A','JM','Educación Básica','0001660468');
call sp_agregarPersona2(39118,'2023116','Fernando Andrés','Gálvez Mancilla','Tercero','BA3DM','N/A','JM','Educación Básica','0090518386');
call sp_agregarPersona2(39119,'2023073','Rodrigo Josué','García Quemé','Tercero','BA3DM','N/A','JM','Educación Básica','0006954461');
call sp_agregarPersona2(39120,'2023006','Walter José Eduardo','Godoy Bran','Tercero','BA3DM','N/A','JM','Educación Básica','0006959460');
call sp_agregarPersona2(39121,'2023183','Miguel Ángel','Guzmán Dávila','Tercero','BA3DM','N/A','JM','Educación Básica','0007333172');
call sp_agregarPersona2(39122,'2023552','Luis Ángel Josué','Hernández Ramírez','Tercero','BA3DM','N/A','JM','Educación Básica','0005581135');
call sp_agregarPersona2(39123,'2025397','Gabriel Eduardo','Lemus Carcuz','Tercero','BA3DM','N/A','JM','Educación Básica','0010034942');
call sp_agregarPersona2(39124,'2023077','Héctor Ismael','Lucas Lorenzo','Tercero','BA3DM','N/A','JM','Educación Básica','0010035137');
call sp_agregarPersona2(39125,'2023382','Emilio José','Madrid Villegas','Tercero','BA3DM','N/A','JM','Educación Básica','0010035924');
call sp_agregarPersona2(39126,'2023307','Diego Josué','Martínez Pirir','Tercero','BA3DM','N/A','JM','Educación Básica','0010034554');
call sp_agregarPersona2(39127,'2022413','Abner Haziel','Meléndez Ovando','Tercero','BA3DM','N/A','JM','Educación Básica','0006816381');
call sp_agregarPersona2(39128,'2023379','Randy anderson','Mendez palencia','Tercero','BA3DM','N/A','JM','Educación Básica','0091083057');
call sp_agregarPersona2(39129,'2023150','Saúl Estuardo','Montenegro Castillo','Tercero','BA3DM','N/A','JM','Educación Básica','0005524004');
call sp_agregarPersona2(39130,'2025238','José Julian','Montezuma Alvarez','Tercero','BA3DM','N/A','JM','Educación Básica','0006816333');
call sp_agregarPersona2(39131,'2023360','Gabriel Estuardo','Panjoj Ramírez','Tercero','BA3DM','N/A','JM','Educación Básica','0090539398');
call sp_agregarPersona2(39132,'2023196','Cristofer Daniel Alejandro','Ramos del Cid','Tercero','BA3DM','N/A','JM','Educación Básica','0091085291');
call sp_agregarPersona2(39133,'2023111','Diego Alejandro','Reyes Contreras','Tercero','BA3DM','N/A','JM','Educación Básica','0006812224');
call sp_agregarPersona2(39134,'2023352','Angel Gabriel Orlando','Rodríguez Velásquez','Tercero','BA3DM','N/A','JM','Educación Básica','0006613038');
call sp_agregarPersona2(39135,'2023217','Nestor Gidiani','Sánchez Luna','Tercero','BA3DM','N/A','JM','Educación Básica','0006623984');
call sp_agregarPersona2(39136,'2023067','Jeshua jonathan alejandro','Urbina hernandez','Tercero','BA3DM','N/A','JM','Educación Básica','0005523988');
call sp_agregarPersona2(39137,'2025545','Angel Daniel','Xajil Hernández','Tercero','BA3DM','N/A','JM','Educación Básica','0006845862');
call sp_agregarPersona2(39138,'2023347','Andree Santiago','Zabala Ampérez','Tercero','BA3DM','N/A','JM','Educación Básica','0005479332');
call sp_agregarPersona2(39139,'2023080','Luis Angel Alberto','Archila Alvarez','Tercero','BA3EM','N/A','JM','Educación Básica','0006846848');
call sp_agregarPersona2(39140,'2023487','Eitan André','Bringuez Hernández','Tercero','BA3EM','N/A','JM','Educación Básica','0006816405');
call sp_agregarPersona2(39141,'2023460','Jonathan Sebastián','Cahuex Lopez','Tercero','BA3EM','N/A','JM','Educación Básica','0013674594');
call sp_agregarPersona2(39142,'2025499','Luis Fernando','Castro García','Tercero','BA3EM','N/A','JM','Educación Básica','0005500482');
call sp_agregarPersona2(39143,'2025471','Josué Daniel','De León Soto','Tercero','BA3EM','N/A','JM','Educación Básica','0013700341');
call sp_agregarPersona2(39144,'2023037','Edmond Enrique','Dubón Agtún','Tercero','BA3EM','N/A','JM','Educación Básica','0013656051');
call sp_agregarPersona2(39145,'2023470','Mariano Alessandro','Fernández Hernández','Tercero','BA3EM','N/A','JM','Educación Básica','0013699871');
call sp_agregarPersona2(39146,'2023143','Santiago André','Gálvez Muñoz','Tercero','BA3EM','N/A','JM','Educación Básica','0001518864');
call sp_agregarPersona2(39147,'2025435','Julián Esteban','García Soto','Tercero','BA3EM','N/A','JM','Educación Básica','0008556353');
call sp_agregarPersona2(39148,'2023602','Angel Daniel','Gomez Michicoj','Tercero','BA3EM','N/A','JM','Educación Básica','0001518491');
call sp_agregarPersona2(39149,'2023229','Robben Enrique','Guzmán Pineda','Tercero','BA3EM','N/A','JM','Educación Básica','0008571345');
call sp_agregarPersona2(39150,'2023545','Jonathan Sebastián','Guzmán Ramírez','Tercero','BA3EM','N/A','JM','Educación Básica','0005553451');
call sp_agregarPersona2(39151,'2023587','Christian Fernando','Hernández Chávez','Tercero','BA3EM','N/A','JM','Educación Básica','0000158486');
call sp_agregarPersona2(39152,'2023184','Victor Javier','Hernández Sajquin','Tercero','BA3EM','N/A','JM','Educación Básica','0007537044');
call sp_agregarPersona2(39153,'2023574','Esdras Aarón','Istupe de Paz','Tercero','BA3EM','N/A','JM','Educación Básica','0007619850');
call sp_agregarPersona2(39154,'2023087','Rhyan Fernando','Mancilla Contreras','Tercero','BA3EM','N/A','JM','Educación Básica','0007411381');
call sp_agregarPersona2(39155,'2023445','Felix Sebastian','Marroquin Chen','Tercero','BA3EM','N/A','JM','Educación Básica','0000389182');
call sp_agregarPersona2(39156,'2023068','Gestember Esteve','Martinez Reyes','Tercero','BA3EM','N/A','JM','Educación Básica','0007411472');
call sp_agregarPersona2(39157,'2023405','Sebastian David','Melgar Aragón','Tercero','BA3EM','N/A','JM','Educación Básica','0000977910');
call sp_agregarPersona2(39158,'2025475','Anderson Damian','Mendoza Saj','Tercero','BA3EM','N/A','JM','Educación Básica','0007283510');
call sp_agregarPersona2(39159,'2023381','Rodrigo Alejandro','Morales Soto','Tercero','BA3EM','N/A','JM','Educación Básica','0008557417');
call sp_agregarPersona2(39160,'2025481','Sebastian Tadeo','Paredes Pirir','Tercero','BA3EM','N/A','JM','Educación Básica','0001517740');
call sp_agregarPersona2(39161,'2023355','Henry Santiago','Pineda Ramirez','Tercero','BA3EM','N/A','JM','Educación Básica','0005479331');
call sp_agregarPersona2(39162,'2025410','Martin Alejandro','Rodríguez Velásquez','Tercero','BA3EM','N/A','JM','Educación Básica','0008539679');
call sp_agregarPersona2(39163,'2025373','Jonathan Israel','Tecun Morales','Tercero','BA3EM','N/A','JM','Educación Básica','0005678670');
call sp_agregarPersona2(39164,'2023581','JENCARLOS DONELITH','TORRES VICENTE','Tercero','BA3EM','N/A','JM','Educación Básica','0005678667');
call sp_agregarPersona2(39165,'2023339','Danny Anderson','Urbina Sigüenza','Tercero','BA3EM','N/A','JM','Educación Básica','0005678604');
call sp_agregarPersona2(39166,'2023075','Diego Alejandro','Xuya Alvarado','Tercero','BA3EM','N/A','JM','Educación Básica','0002857074');
call sp_agregarPersona2(39167,'2024317','Josué David','Aguilar Cal','Segundo','BA2AM','N/A','JM','Educación Básica','0007411469');
call sp_agregarPersona2(39168,'2024415','Eitan Andree','Aldana Barrios','Segundo','BA2AM','N/A','JM','Educación Básica','0000971658');
call sp_agregarPersona2(39169,'2025466','Justin Steven','Aquino Argueta','Segundo','BA2AM','N/A','JM','Educación Básica','0007411421');
call sp_agregarPersona2(39170,'2024121','Hamilton Manuel','Carranza Castañeda','Segundo','BA2AM','N/A','JM','Educación Básica','0003351405');
call sp_agregarPersona2(39171,'2024053','Augusto José','Cúmez García','Segundo','BA2AM','N/A','JM','Educación Básica','0001172084');
call sp_agregarPersona2(39172,'2024071','Gustavo Salvador','De Leon Morán','Segundo','BA2AM','N/A','JM','Educación Básica','0005963651');
call sp_agregarPersona2(39173,'2024101','LESTER JOSUE','ENRIQUEZ FLORES','Segundo','BA2AM','N/A','JM','Educación Básica','0008509762');
call sp_agregarPersona2(39174,'2025460','Anton Zaid','García Méndez','Segundo','BA2AM','N/A','JM','Educación Básica','0005259433');
call sp_agregarPersona2(39175,'2024355','Christopher Matias','Godinez Ramirez','Segundo','BA2AM','N/A','JM','Educación Básica','0003979381');
call sp_agregarPersona2(39176,'2024006','Francisco Alexander','Grijalva Chutan','Segundo','BA2AM','N/A','JM','Educación Básica','0001911073');
call sp_agregarPersona2(39177,'2024338','Jonatan Santiago','Maldonado Samayoa','Segundo','BA2AM','N/A','JM','Educación Básica','0007704333');
call sp_agregarPersona2(39178,'2024167','Juan De Marco','Meléndrez Castillo','Segundo','BA2AM','N/A','JM','Educación Básica','0001840106');
call sp_agregarPersona2(39179,'2024354','Angel Manuel','Méndez Osorio','Segundo','BA2AM','N/A','JM','Educación Básica','0007412027');
call sp_agregarPersona2(39180,'2024025','Héctor Alejandro','Monterroso Maldonado','Segundo','BA2AM','N/A','JM','Educación Básica','0007412005');
call sp_agregarPersona2(39181,'2024146','Jorge Francisco','Orózco Buchán','Segundo','BA2AM','N/A','JM','Educación Básica','0007396790');
call sp_agregarPersona2(39182,'2024205','Andrés Francisco','Palomino Robles','Segundo','BA2AM','N/A','JM','Educación Básica','0005542626');
call sp_agregarPersona2(39183,'2024147','Saúl Alejandro','Pop Pérez','Segundo','BA2AM','N/A','JM','Educación Básica','0008133835');
call sp_agregarPersona2(39184,'2024122','Josue Daniel','Reyes Lopez','Segundo','BA2AM','N/A','JM','Educación Básica','0005243143');
call sp_agregarPersona2(39185,'2024321','Juancarlos','Rosales De La Roca','Segundo','BA2AM','N/A','JM','Educación Básica','0005234440');
call sp_agregarPersona2(39186,'2024527','JOSUE GABRIEL','SACAGUI LINARES','Segundo','BA2AM','N/A','JM','Educación Básica','0005237666');
call sp_agregarPersona2(39187,'2024161','Jeferson Haroldo','Sánchez Tiu','Segundo','BA2AM','N/A','JM','Educación Básica','0000156540');
call sp_agregarPersona2(39188,'2024184','Diego Fernando','Tul Pinto','Segundo','BA2AM','N/A','JM','Educación Básica','0001131414');
call sp_agregarPersona2(39189,'2024501','Esaú César Manuel','Vélasquez Suruy','Segundo','BA2AM','N/A','JM','Educación Básica','0008048619');
call sp_agregarPersona2(39190,'2024185','Nicolás Alfredo','Xol Cac','Segundo','BA2AM','N/A','JM','Educación Básica','0001679612');
call sp_agregarPersona2(39191,'2024538','Alejandro','Almazán Rodríguez','Segundo','BA2BM','N/A','JM','Educación Básica','0006558213');
call sp_agregarPersona2(39192,'2024519','Diego FERNANDO','Aquino Gomez','Segundo','BA2BM','N/A','JM','Educación Básica','0001508848');
call sp_agregarPersona2(39193,'2024076','Gabriel Estuardo','Castro Hernández','Segundo','BA2BM','N/A','JM','Educación Básica','0001947041');
call sp_agregarPersona2(39194,'2024472','Angel Gabriel','Chacón Sucuquí','Segundo','BA2BM','N/A','JM','Educación Básica','0003980506');
call sp_agregarPersona2(39195,'2023165','Angel Gabriel','Coronado Mendoza','Segundo','BA2BM','N/A','JM','Educación Básica','0002832831');
call sp_agregarPersona2(39196,'2024300','Jorge Santiago','De León Ortiz','Segundo','BA2BM','N/A','JM','Educación Básica','0004707496');
call sp_agregarPersona2(39197,'2024187','Kevin Alexander','Felipe Choreque','Segundo','BA2BM','N/A','JM','Educación Básica','0005992560');
call sp_agregarPersona2(39198,'2024246','Josue Rodrigo','Gómez Escobar','Segundo','BA2BM','N/A','JM','Educación Básica','0006001343');
call sp_agregarPersona2(39199,'2024346','Josué Alejandro','Hernández Rivera','Segundo','BA2BM','N/A','JM','Educación Básica','0006715059');
call sp_agregarPersona2(39200,'2024450','Pablo Andrés','Juárez Pixtun','Segundo','BA2BM','N/A','JM','Educación Básica','0005622364');
call sp_agregarPersona2(39201,'2025531','Diego Alejandro','Marroquin Schaeffer','Segundo','BA2BM','N/A','JM','Educación Básica','0005648366');
call sp_agregarPersona2(39202,'2024198','Daniel Alejandro','Martínez Montenegro','Segundo','BA2BM','N/A','JM','Educación Básica','0005502131');
call sp_agregarPersona2(39203,'2025485','Raúl Andrés','Menchú Barrios','Segundo','BA2BM','N/A','JM','Educación Básica','0006714975');
call sp_agregarPersona2(39204,'2024301','Mario Adrián','Monzón Palacios','Segundo','BA2BM','N/A','JM','Educación Básica','0006841287');
call sp_agregarPersona2(39205,'2024056','Ian André','Morales Lobos','Segundo','BA2BM','N/A','JM','Educación Básica','0005626443');
call sp_agregarPersona2(39206,'2024364','Axel Rodrigo','Ortiz Martinez','Segundo','BA2BM','N/A','JM','Educación Básica','0006691459');
call sp_agregarPersona2(39207,'2024263','Nery Sebastian','Paredes Cuellar','Segundo','BA2BM','N/A','JM','Educación Básica','0005606658');
call sp_agregarPersona2(39208,'2024400','Samuel Sebastián','Realiquez Noriega','Segundo','BA2BM','N/A','JM','Educación Básica','0005638173');
call sp_agregarPersona2(39209,'2025503','Jose Andre','Rosales Maradiaga','Segundo','BA2BM','N/A','JM','Educación Básica','0003360776');
call sp_agregarPersona2(39210,'2024423','Emilio Andre','Saenz Corado','Segundo','BA2BM','N/A','JM','Educación Básica','0006798537');
call sp_agregarPersona2(39211,'2024367','Daniel Jacob','Sicajau Pascual','Segundo','BA2BM','N/A','JM','Educación Básica','0005497866');
call sp_agregarPersona2(39212,'2024148','Pablo Alexander','Ventura Cotom','Segundo','BA2BM','N/A','JM','Educación Básica','0005511920');
call sp_agregarPersona2(39213,'2025236','Mathías Israel','Yat López','Segundo','BA2BM','N/A','JM','Educación Básica','0002763201');
call sp_agregarPersona2(39214,'2024366','Mateo Fabián','Alonzo Nitsh','Segundo','BA2CM','N/A','JM','Educación Básica','0002779376');
call sp_agregarPersona2(39215,'2024166','Angel David','Artiga Perez','Segundo','BA2CM','N/A','JM','Educación Básica','0005501508');
call sp_agregarPersona2(39216,'2024398','André Sebastián','Barrientos Luna','Segundo','BA2CM','N/A','JM','Educación Básica','0002746509');
call sp_agregarPersona2(39217,'2024298','Iván Alexander','Chacón Escobar','Segundo','BA2CM','N/A','JM','Educación Básica','0090521210');
call sp_agregarPersona2(39218,'2024311','Marcos Diego Fernando','Chinchilla García','Segundo','BA2CM','N/A','JM','Educación Básica','0090543465');
call sp_agregarPersona2(39219,'2024389','Angel David','Cox Rodríguez','Segundo','BA2CM','N/A','JM','Educación Básica','0005501349');
call sp_agregarPersona2(39220,'2024149','Diego Javier','Franco Rodriguez','Segundo','BA2CM','N/A','JM','Educación Básica','0090521230');
call sp_agregarPersona2(39221,'2024478','José Javier','Guerra Castillo','Segundo','BA2CM','N/A','JM','Educación Básica','0090532504');
call sp_agregarPersona2(39222,'2023547','Joshua Joao','Hernández Herrera','Segundo','BA2CM','N/A','JM','Educación Básica','0090518552');
call sp_agregarPersona2(39223,'2024118','EDUARDO EMANUEL','HERNÁNDEZ TEMA','Segundo','BA2CM','N/A','JM','Educación Básica','0005614114');
call sp_agregarPersona2(39224,'2024419','José Andrés','Lemus Toledo','Segundo','BA2CM','N/A','JM','Educación Básica','0005414270');
call sp_agregarPersona2(39225,'2024343','Alexis Omar','Luna Sisimit','Segundo','BA2CM','N/A','JM','Educación Básica','0005402594');
call sp_agregarPersona2(39226,'2024137','William Emiliano','Martínez Morales','Segundo','BA2CM','N/A','JM','Educación Básica','0091071221');
call sp_agregarPersona2(39227,'2024090','José Alejandro','Mazariegos Morales','Segundo','BA2CM','N/A','JM','Educación Básica','0091100698');
call sp_agregarPersona2(39228,'2024175','Esteban Andrés','Morales Hernández','Segundo','BA2CM','N/A','JM','Educación Básica','0000134961');
call sp_agregarPersona2(39229,'2024105','Mario Armando','Moran Granados','Segundo','BA2CM','N/A','JM','Educación Básica','0004319015');
call sp_agregarPersona2(39230,'2025538','Javier Alejandro','Ortiz Recinos','Segundo','BA2CM','N/A','JM','Educación Básica','0002748616');
call sp_agregarPersona2(39231,'2024496','Byron Josué','Pec Castillo','Segundo','BA2CM','N/A','JM','Educación Básica','0000947941');
call sp_agregarPersona2(39232,'2024206','Pablo Daniel','Quijivix Lux','Segundo','BA2CM','N/A','JM','Educación Básica','0004809618');
call sp_agregarPersona2(39233,'2024312','Daniel Eduardo','Quim Chapaz','Segundo','BA2CM','N/A','JM','Educación Básica','0001507782');
call sp_agregarPersona2(39234,'2024489','Jose Eliceo','Rodas Barahona','Segundo','BA2CM','N/A','JM','Educación Básica','0007409104');
call sp_agregarPersona2(39235,'2024529','Jhoxua Imanol','Rodríguez Enriquez','Segundo','BA2CM','N/A','JM','Educación Básica','0007826752');
call sp_agregarPersona2(39236,'2023356','Sander Emmanuel','Rosales Morales','Segundo','BA2CM','N/A','JM','Educación Básica','0007269423');
call sp_agregarPersona2(39237,'2024313','Lucian Ricardo','Sinay Canel','Segundo','BA2CM','N/A','JM','Educación Básica','0000188647');
call sp_agregarPersona2(39238,'2024482','Josué Samuel','Soto Puac','Segundo','BA2CM','N/A','JM','Educación Básica','0000142629');
call sp_agregarPersona2(39239,'2024320','Diego Alfredo','Valenzuela Santizo','Segundo','BA2CM','N/A','JM','Educación Básica','0000165907');
call sp_agregarPersona2(39240,'2024522','André Edgar Alejandro','Villatoro Meléndez','Segundo','BA2CM','N/A','JM','Educación Básica','0000149151');
call sp_agregarPersona2(39241,'2024551','Percie Alexandré','Xec González','Segundo','BA2CM','N/A','JM','Educación Básica','0005487873');
call sp_agregarPersona2(39242,'2025480','Jose Adolfo','Barrios Bonilla','Segundo','BA2DM','N/A','JM','Educación Básica','0006842787');
call sp_agregarPersona2(39243,'2024211','Miguel Andree','Castañeda Florian','Segundo','BA2DM','N/A','JM','Educación Básica','0006843362');
call sp_agregarPersona2(39244,'2024116','Rodrigo Alejandro','Contreras García','Segundo','BA2DM','N/A','JM','Educación Básica','0005553766');
call sp_agregarPersona2(39245,'2025588','Darvin Alfredo','Cucul Salquil','Segundo','BA2DM','N/A','JM','Educación Básica','0005518137');
call sp_agregarPersona2(39246,'2024292','Williams Claudio Roberto','de León Franco','Segundo','BA2DM','N/A','JM','Educación Básica','0005503021');
call sp_agregarPersona2(39247,'2024416','Jhosep Santiago','Donis Canel','Segundo','BA2DM','N/A','JM','Educación Básica','0005609832');
call sp_agregarPersona2(39248,'2024119','Manuel Sebastián','Fuentes De León','Segundo','BA2DM','N/A','JM','Educación Básica','0006393838');
call sp_agregarPersona2(39249,'2024335','Ángel Ernesto','González Ixpancoc','Segundo','BA2DM','N/A','JM','Educación Básica','0090541426');
call sp_agregarPersona2(39250,'2024432','Santiago Alexander','Guzmán Cabrera','Segundo','BA2DM','N/A','JM','Educación Básica','0006605783');
call sp_agregarPersona2(39251,'2025458','José Rodrigo','Herrera Pérez','Segundo','BA2DM','N/A','JM','Educación Básica','0006701238');
call sp_agregarPersona2(39252,'2025561','Juan Mateo','Macz Vivar','Segundo','BA2DM','N/A','JM','Educación Básica','0006597694');
call sp_agregarPersona2(39253,'2024405','Pablo Leonardo','Marroquin Chen','Segundo','BA2DM','N/A','JM','Educación Básica','0091071292');
call sp_agregarPersona2(39254,'2024145','Jason Steven','Mazariegos Santos','Segundo','BA2DM','N/A','JM','Educación Básica','0006445065');
call sp_agregarPersona2(39255,'2024085','ALVARO ANTONIO VALENTIN','MONROY DONIS','Segundo','BA2DM','N/A','JM','Educación Básica','0006764986');
call sp_agregarPersona2(39256,'2023484','Matthew André','Muñoz Gerónimo','Segundo','BA2DM','N/A','JM','Educación Básica','0090542781');
call sp_agregarPersona2(39257,'2024186','Vecker Alfredo','Palacios Marquez','Segundo','BA2DM','N/A','JM','Educación Básica','0090518574');
call sp_agregarPersona2(39258,'2024467','Jose Adrian','Pedraz Aparicio','Segundo','BA2DM','N/A','JM','Educación Básica','0090518615');
call sp_agregarPersona2(39259,'2024179','Álvaro Enrique','Recinos Lima','Segundo','BA2DM','N/A','JM','Educación Básica','0006846713');
call sp_agregarPersona2(39260,'2024178','Diego Alejandro','Recinos Lima','Segundo','BA2DM','N/A','JM','Educación Básica','0006597716');
call sp_agregarPersona2(39261,'2024377','Rolando Isaac','Rodriguez de Leon','Segundo','BA2DM','N/A','JM','Educación Básica','0006757593');
call sp_agregarPersona2(39262,'2024209','Daniel Alexander','Rodríguez Montúfar','Segundo','BA2DM','N/A','JM','Educación Básica','0090532482');
call sp_agregarPersona2(39263,'2024141','Axel Javier','Telón Aldana','Segundo','BA2DM','N/A','JM','Educación Básica','0005371809');
call sp_agregarPersona2(39264,'2024305','Samuel Andres','Vargas Guzmán','Segundo','BA2DM','N/A','JM','Educación Básica','0006816615');
call sp_agregarPersona2(39265,'2024471','Luis Pedro','Villagrán Real','Segundo','BA2DM','N/A','JM','Educación Básica','0005509611');
call sp_agregarPersona2(39266,'2023162','Miguel Alfonso','Xuc Torres','Segundo','BA2DM','N/A','JM','Educación Básica','0005602067');
call sp_agregarPersona2(39267,'2023083','Esteban Emilio','Zapet González','Segundo','BA2DM','N/A','JM','Educación Básica','0005402307');
call sp_agregarPersona2(39268,'2024130','JUAN SEBASTIAN','ALTÁN CORTEZ','Segundo','BA2EM','N/A','JM','Educación Básica','0006798593');
call sp_agregarPersona2(39269,'2025235','Benjamín Alejandro','Barrios Leonardo','Segundo','BA2EM','N/A','JM','Educación Básica','0091094231');
call sp_agregarPersona2(39270,'2024070','Allan José Estuardo','Bautista González','Segundo','BA2EM','N/A','JM','Educación Básica','0006394765');
call sp_agregarPersona2(39271,'2024168','Abner Stiven','Blanco Luna','Segundo','BA2EM','N/A','JM','Educación Básica','0006395034');
call sp_agregarPersona2(39272,'2024303','Ian Alexander','Castillo Monzón','Segundo','BA2EM','N/A','JM','Educación Básica','0091084009');
call sp_agregarPersona2(39273,'2024535','Jeferson Gabriel','Culajay Pac','Segundo','BA2EM','N/A','JM','Educación Básica','0006778081');
call sp_agregarPersona2(39274,'2024294','Kevin Estuardo','De León Milian','Segundo','BA2EM','N/A','JM','Educación Básica','0005444623');
call sp_agregarPersona2(39275,'2025137','Gadiel Sebastiàn','Depaz Toj','Segundo','BA2EM','N/A','JM','Educación Básica','0091088284');
call sp_agregarPersona2(39276,'2024284','Julio david','Garcia de la cruz','Segundo','BA2EM','N/A','JM','Educación Básica','0090516708');
call sp_agregarPersona2(39277,'2024104','CRISTOPHER EMILIO','HERNANDEZ CARRERA','Segundo','BA2EM','N/A','JM','Educación Básica','0006780119');
call sp_agregarPersona2(39278,'2024469','José Ignacio','Hurtarte Reyes','Segundo','BA2EM','N/A','JM','Educación Básica','0091068458');
call sp_agregarPersona2(39279,'2025392','Javier Alejandro','Lopez Franco','Segundo','BA2EM','N/A','JM','Educación Básica','0091086008');
call sp_agregarPersona2(39280,'2024091','Pablo Samuel','Marroquín Núñez','Segundo','BA2EM','N/A','JM','Educación Básica','0091067058');
call sp_agregarPersona2(39281,'2024510','Jefferson Josué','Medina Ubeda','Segundo','BA2EM','N/A','JM','Educación Básica','0091103119');
call sp_agregarPersona2(39282,'2024218','Daniel Eduardo','Monterroso López','Segundo','BA2EM','N/A','JM','Educación Básica','0005620910');
call sp_agregarPersona2(39283,'2024376','Melvin Javier','Orellana Dieguez','Segundo','BA2EM','N/A','JM','Educación Básica','0090518572');
call sp_agregarPersona2(39284,'2024272','Joel Abraham','Osorio Ixpatá','Segundo','BA2EM','N/A','JM','Educación Básica','0090545612');
call sp_agregarPersona2(39285,'2024441','José Alejandro','Palala Velasquez','Segundo','BA2EM','N/A','JM','Educación Básica','0006843340');
call sp_agregarPersona2(39286,'2025489','EDGAR MIGUEL','PIXTUN HERNANDEZ','Segundo','BA2EM','N/A','JM','Educación Básica','0006650662');
call sp_agregarPersona2(39287,'2024164','Anderson Fernando','Ramírez Morales','Segundo','BA2EM','N/A','JM','Educación Básica','0006793665');
call sp_agregarPersona2(39288,'2024262','ANGEL ALBERTO','RODRÍGUEZ SAY','Segundo','BA2EM','N/A','JM','Educación Básica','0006799977');
call sp_agregarPersona2(39289,'2025456','Jose Marcelo','Samayoa Aldana','Segundo','BA2EM','N/A','JM','Educación Básica','0006800109');
call sp_agregarPersona2(39290,'2025570','Jose Javier','Santizo García','Segundo','BA2EM','N/A','JM','Educación Básica','0007315678');
call sp_agregarPersona2(39291,'2024281','Angel Gabriel','Torres Santizo','Segundo','BA2EM','N/A','JM','Educación Básica','0090521084');
call sp_agregarPersona2(39292,'2024368','Gabriel Antonio','Vargas Esquivel','Segundo','BA2EM','N/A','JM','Educación Básica','0090521232');
call sp_agregarPersona2(39293,'2024306','Johan Alexander','Villeda Moya','Segundo','BA2EM','N/A','JM','Educación Básica','0006395037');
call sp_agregarPersona2(39294,'2024276','Angel Josue','Yaxón Pérez','Segundo','BA2EM','N/A','JM','Educación Básica','0006393918');
call sp_agregarPersona2(39295,'2024008','Gerardo Noé','Zacarías Oxcal','Segundo','BA2EM','N/A','JM','Educación Básica','0006602623');
call sp_agregarPersona2(39296,'2025450','Jenson André','Abac Sican','Primero','BA1AM','N/A','JM','Educación Básica','0091075926');
call sp_agregarPersona2(39297,'2025413','Christopher Andreeé','Afre Díaz','Primero','BA1AM','N/A','JM','Educación Básica','0006701252');
call sp_agregarPersona2(39298,'2025580','Aarón Sebastián','Aguilar Barillas','Primero','BA1AM','N/A','JM','Educación Básica','0006555452');
call sp_agregarPersona2(39299,'2025329','Marvin Orlando','Alvarez Velásquez','Primero','BA1AM','N/A','JM','Educación Básica','0090518619');
call sp_agregarPersona2(39300,'2025430','Santiago Javier','Avalos Lemus','Primero','BA1AM','N/A','JM','Educación Básica','0007303334');
call sp_agregarPersona2(39301,'2025492','Jacobo Fabrizio','Castañón Ibáñez','Primero','BA1AM','N/A','JM','Educación Básica','0006749529');
call sp_agregarPersona2(39302,'2025290','Ronald Alexander','Cifuentes Ramos','Primero','BA1AM','N/A','JM','Educación Básica','0090521172');
call sp_agregarPersona2(39303,'2025558','Joseph O´nneal','Claudio Yoc','Primero','BA1AM','N/A','JM','Educación Básica','0091089057');
call sp_agregarPersona2(39304,'2025529','Dominick Emanuel','Cruz Najera','Primero','BA1AM','N/A','JM','Educación Básica','0006562926');
call sp_agregarPersona2(39305,'2025320','Lissandro Aarón','Escobar González','Primero','BA1AM','N/A','JM','Educación Básica','0006686148');
call sp_agregarPersona2(39306,'2025186','Rodrigo Alejandro','Estrada Gutierrez','Primero','BA1AM','N/A','JM','Educación Básica','0006556069');
call sp_agregarPersona2(39307,'2025455','ANDERSON EDUARDO','FUENTES PAZ','Primero','BA1AM','N/A','JM','Educación Básica','0090542574');
call sp_agregarPersona2(39308,'2025432','Santiago Alejandro','Godoy Polanco','Primero','BA1AM','N/A','JM','Educación Básica','0006556059');
call sp_agregarPersona2(39309,'2025502','JAVIER ESTUARDO','GONZÁLEZ LÓPEZ','Primero','BA1AM','N/A','JM','Educación Básica','0006562651');
call sp_agregarPersona2(39310,'2025497','Emilio','Gressi López','Primero','BA1AM','N/A','JM','Educación Básica','0091072358');
call sp_agregarPersona2(39311,'2025328','Joseph Michael','Jut Chaperon','Primero','BA1AM','N/A','JM','Educación Básica','0006566333');
call sp_agregarPersona2(39312,'2025339','José Guillermo','Leiva Palma','Primero','BA1AM','N/A','JM','Educación Básica','0006700166');
call sp_agregarPersona2(39313,'2025374','Jorge Emmanuel','Lopez Morales','Primero','BA1AM','N/A','JM','Educación Básica','0006709650');
call sp_agregarPersona2(39314,'2025496','WILSON STEVEN','MÁRQUEZ ORDOÑEZ','Primero','BA1AM','N/A','JM','Educación Básica','0007296031');
call sp_agregarPersona2(39315,'2025526','José Ramon','Martínez Pineda','Primero','BA1AM','N/A','JM','Educación Básica','0006755282');
call sp_agregarPersona2(39316,'2025258','Matias Esau','Morales Pérez','Primero','BA1AM','N/A','JM','Educación Básica','0091081344');
call sp_agregarPersona2(39317,'2025008','JOSSEF ANDRE MORAN URBINA','MORAN URBINA','Primero','BA1AM','N/A','JM','Educación Básica','0010071737');
call sp_agregarPersona2(39318,'2025227','MANUEL DE JESÚS','ORELLANA TUCH','Primero','BA1AM','N/A','JM','Educación Básica','0091092556');
call sp_agregarPersona2(39319,'2025333','Jose Gabriel','Perez Avalos','Primero','BA1AM','N/A','JM','Educación Básica','0091080995');
call sp_agregarPersona2(39320,'2025007','Axel joel','Pérez Gutiérrez','Primero','BA1AM','N/A','JM','Educación Básica','0006846833');
call sp_agregarPersona2(39321,'2025188','ANGEL ROBERTO DE JESUS','QUEZADA VASQUEZ','Primero','BA1AM','N/A','JM','Educación Básica','0006842019');
call sp_agregarPersona2(39322,'2025495','Cesar Adrian','Raxón Urizar','Primero','BA1AM','N/A','JM','Educación Básica','0013378438');
call sp_agregarPersona2(39323,'2025482','Alan Gabriel','Reyes Cordero','Primero','BA1AM','N/A','JM','Educación Básica','0005423952');
call sp_agregarPersona2(39324,'2025003','Diego Eduardo','Rosales Castrillo','Primero','BA1AM','N/A','JM','Educación Básica','0013378448');
call sp_agregarPersona2(39325,'2025210','Oscar Rafael','Santisteban Aguilar','Primero','BA1AM','N/A','JM','Educación Básica','0013377607');
call sp_agregarPersona2(39326,'2025500','Luis Ardani','Sosa López','Primero','BA1AM','N/A','JM','Educación Básica','0005718486');
call sp_agregarPersona2(39327,'2025524','Diego Alejandro','Vasquez Hernández','Primero','BA1AM','N/A','JM','Educación Básica','0005719525');
call sp_agregarPersona2(39328,'2025093','David Daniel','Velásquez Domínguez','Primero','BA1AM','N/A','JM','Educación Básica','0013431325');
call sp_agregarPersona2(39329,'2025586','Ignacio Agustín','Zacarías Chinchilla','Primero','BA1AM','N/A','JM','Educación Básica','0007274545');
call sp_agregarPersona2(39330,'2025247','IKER ESTUARDO','ACEITUNO BONILLA','Primero','BA1BM','N/A','JM','Educación Básica','0013431990');
call sp_agregarPersona2(39331,'2025391','Victor Sebastian','Aguilar Vásquez','Primero','BA1BM','N/A','JM','Educación Básica','0006778490');
call sp_agregarPersona2(39332,'2025198','Alex Darío','Andino Alvarado','Primero','BA1BM','N/A','JM','Educación Básica','0005747424');
call sp_agregarPersona2(39333,'2025420','Diego Francisco','Avendaño Castellón','Primero','BA1BM','N/A','JM','Educación Básica','0006597664');
call sp_agregarPersona2(39334,'2025498','Jorge Andrés','Castro García','Primero','BA1BM','N/A','JM','Educación Básica','0006780128');
call sp_agregarPersona2(39335,'2025370','DILAN ELÍAS JOSUÉ','COC CUYUCH','Primero','BA1BM','N/A','JM','Educación Básica','0090964854');
call sp_agregarPersona2(39336,'2025066','Jesús Andre','Colindres Pineda','Primero','BA1BM','N/A','JM','Educación Básica','0006610064');
call sp_agregarPersona2(39337,'2025474','José Alejandro','Fernández Ortiz','Primero','BA1BM','N/A','JM','Educación Básica','0006778072');
call sp_agregarPersona2(39338,'2025322','Rodolfo Santiago','Figueroa Argueta','Primero','BA1BM','N/A','JM','Educación Básica','0006613978');
call sp_agregarPersona2(39339,'2025224','Omar Jadyel','Fuentes Tonoc','Primero','BA1BM','N/A','JM','Educación Básica','0006605616');
call sp_agregarPersona2(39340,'2025389','EMILIO JOSE','GOMEZ GUERRERO','Primero','BA1BM','N/A','JM','Educación Básica','0006697896');
call sp_agregarPersona2(39341,'2025470','Mario Esteban','Gruzzi Meneses','Primero','BA1BM','N/A','JM','Educación Básica','0007300647');
call sp_agregarPersona2(39342,'2025187','Derek José Enrique','Guerra Cabrera','Primero','BA1BM','N/A','JM','Educación Básica','0005747216');
call sp_agregarPersona2(39343,'2025593','Luis Enrique','Hernandez Reyes','Primero','BA1BM','N/A','JM','Educación Básica','0091089376');
call sp_agregarPersona2(39344,'2025581','Cristian Nery Samuel','Juárez Aldana','Primero','BA1BM','N/A','JM','Educación Básica','0090542486');
call sp_agregarPersona2(39345,'2025381','Abraham Isaac','Lacayo Morataya','Primero','BA1BM','N/A','JM','Educación Básica','0006609264');
call sp_agregarPersona2(39346,'2025221','Luis Armando','Lima Samuy','Primero','BA1BM','N/A','JM','Educación Básica','0090521173');
call sp_agregarPersona2(39347,'2024258','Cristopher Alexander','López Reyes','Primero','BA1BM','N/A','JM','Educación Básica','0090966889');
call sp_agregarPersona2(39348,'2025113','CARLOS ADRIAN','MARROQUIN GOMEZ','Primero','BA1BM','N/A','JM','Educación Básica','0005542994');
call sp_agregarPersona2(39349,'2025253','Pablo Alberto','Mazariegos Escobar','Primero','BA1BM','N/A','JM','Educación Básica','0006559929');
call sp_agregarPersona2(39350,'2025325','Kevin Antonio','Mendizabal Arriaza','Primero','BA1BM','N/A','JM','Educación Básica','0006562945');
call sp_agregarPersona2(39351,'2025415','Brian Adrian','Moreno Jolón','Primero','BA1BM','N/A','JM','Educación Básica','0090518595');
call sp_agregarPersona2(39352,'2025252','Dorian Adiel','Natareno García','Primero','BA1BM','N/A','JM','Educación Básica','0090966913');
call sp_agregarPersona2(39353,'2025555','Jonathan Alexander Josue','Osorio Lux','Primero','BA1BM','N/A','JM','Educación Básica','0091066019');
call sp_agregarPersona2(39354,'2025520','Axel Santiago','Perez Garcia','Primero','BA1BM','N/A','JM','Educación Básica','0090520711');
call sp_agregarPersona2(39355,'2025511','Cristian Adolfo','Pérez Pérez','Primero','BA1BM','N/A','JM','Educación Básica','0006402080');
call sp_agregarPersona2(39356,'2025331','Santiago Emanuel','Quib Rosales','Primero','BA1BM','N/A','JM','Educación Básica','0091103789');
call sp_agregarPersona2(39357,'2025249','Pablo Humberto','Reyes Gil','Primero','BA1BM','N/A','JM','Educación Básica','0006691510');
call sp_agregarPersona2(39358,'2025356','Angel Arturo','Reynoso Xaper','Primero','BA1BM','N/A','JM','Educación Básica','0091073530');
call sp_agregarPersona2(39359,'2025199','Andres Alexander','Rosales Sipaque','Primero','BA1BM','N/A','JM','Educación Básica','0006699070');
call sp_agregarPersona2(39360,'2025264','Sebasthian Alfredo','Saloj Garcia','Primero','BA1BM','N/A','JM','Educación Básica','0091091203');
call sp_agregarPersona2(39361,'2025326','Diego Alejandro','Sequén Ruano','Primero','BA1BM','N/A','JM','Educación Básica','0013377195');
call sp_agregarPersona2(39362,'2025033','Ian Josué','Taracena Gudiel','Primero','BA1BM','N/A','JM','Educación Básica','0001040649');
call sp_agregarPersona2(39363,'2025404','Marcos André','Tol Chiroy','Primero','BA1BM','N/A','JM','Educación Básica','0001041975');
call sp_agregarPersona2(39364,'2025427','Santiago David','Vasquez Miranda','Primero','BA1BM','N/A','JM','Educación Básica','0007307483');
call sp_agregarPersona2(39365,'2025136','Jeremy Manuel','Velazques Ronquillo','Primero','BA1BM','N/A','JM','Educación Básica','0000052065');
call sp_agregarPersona2(39366,'2024339','Boris Adiel','Vicente Vicente','Primero','BA1BM','N/A','JM','Educación Básica','0006778447');
call sp_agregarPersona2(39367,'2025473','Dirdam Josue','Agustín Moncada','Primero','BA1CM','N/A','JM','Educación Básica','0006761954');
call sp_agregarPersona2(39368,'2025385','Jiovany Sebastian','Ajquejay Garcia','Primero','BA1CM','N/A','JM','Educación Básica','0006777404');
call sp_agregarPersona2(39369,'2025514','Mateo Josué Alejandro','Aquino Chamalé','Primero','BA1CM','N/A','JM','Educación Básica','0006570810');
call sp_agregarPersona2(39370,'2025002','Josué Emanuel David Fernando','Bámaca Estrada','Primero','BA1CM','N/A','JM','Educación Básica','0005435292');
call sp_agregarPersona2(39371,'2025179','Benjamín Leonel','Bobadilla Túnchez','Primero','BA1CM','N/A','JM','Educación Básica','0013373486');
call sp_agregarPersona2(39372,'2025128','Emilio Jose','Ceballos Valenzuela','Primero','BA1CM','N/A','JM','Educación Básica','0013373287');
call sp_agregarPersona2(39373,'2025490','Alejandro Sebastían','Colo Marroquin','Primero','BA1CM','N/A','JM','Educación Básica','0013372494');
call sp_agregarPersona2(39374,'2025411','Antonio Javier','Cruceras Fiorini','Primero','BA1CM','N/A','JM','Educación Básica','0013372691');
call sp_agregarPersona2(39375,'2025234','Lester Eugenio','Cuz Cholom','Primero','BA1CM','N/A','JM','Educación Básica','0013378240');
call sp_agregarPersona2(39376,'2025010','Diego Sebastian','Figueroa Calderón','Primero','BA1CM','N/A','JM','Educación Básica','0007268768');
call sp_agregarPersona2(39377,'2025232','Hénderson Winston','Franco Morales','Primero','BA1CM','N/A','JM','Educación Básica','0006597718');
call sp_agregarPersona2(39378,'2025560','Juan José','Gálvez Pineda','Primero','BA1CM','N/A','JM','Educación Básica','0006767593');
call sp_agregarPersona2(39379,'2025100','Daniel Ivan','Gomez Pineda','Primero','BA1CM','N/A','JM','Educación Básica','0005505251');
call sp_agregarPersona2(39380,'2025477','Angel Gabriel','Hernández Cuyuch','Primero','BA1CM','N/A','JM','Educación Básica','0004806553');
call sp_agregarPersona2(39381,'2025099','CARLOS ESTUARDO','LÓPEZ ALBEÑO','Primero','BA1CM','N/A','JM','Educación Básica','0007702668');
call sp_agregarPersona2(39382,'2025310','Fernando Javier','Hernández Ixcot','Primero','BA1CM','N/A','JM','Educación Básica','0007308905');
call sp_agregarPersona2(39383,'2025488','Roger Andrés','Loayes Camey','Primero','BA1CM','N/A','JM','Educación Básica','0013378003');
call sp_agregarPersona2(39384,'2025426','Dennis Emmanuel','Lucas Lorenzo','Primero','BA1CM','N/A','JM','Educación Básica','0006161637');
call sp_agregarPersona2(39385,'2025543','Diego Alejandro','Marroquín Pérez','Primero','BA1CM','N/A','JM','Educación Básica','0000949518');
call sp_agregarPersona2(39386,'2025408','Santiago Andre','Menendez Garcia','Primero','BA1CM','N/A','JM','Educación Básica','0005721695');
call sp_agregarPersona2(39387,'2025111','Jeyco Andreé','Molina Jolomocox','Primero','BA1CM','N/A','JM','Educación Básica','0005721346');
call sp_agregarPersona2(39388,'2025001','José Guillermo','Muñoz Casado','Primero','BA1CM','N/A','JM','Educación Básica','0005721340');
call sp_agregarPersona2(39389,'2025321','Estuardo Nicolas','Ordoñez Chojolan','Primero','BA1CM','N/A','JM','Educación Básica','0005721335');
call sp_agregarPersona2(39390,'2025301','Javier Alejandro','Paredes Diaz','Primero','BA1CM','N/A','JM','Educación Básica','0008009667');
call sp_agregarPersona2(39391,'2025182','Selvin Jose','Pérez Gonzalez','Primero','BA1CM','N/A','JM','Educación Básica','0007998406');
call sp_agregarPersona2(39392,'2024465','Manuel Eduardo','Pérez Quinilla','Primero','BA1CM','N/A','JM','Educación Básica','0007998923');
call sp_agregarPersona2(39393,'2025242','Ángel David','Reyes Hernández','Primero','BA1CM','N/A','JM','Educación Básica','0007992796');
call sp_agregarPersona2(39394,'2025418','Josecarlos','Rosales De La Roca','Primero','BA1CM','N/A','JM','Educación Básica','0007288361');
call sp_agregarPersona2(39395,'2025583','JUSTIN SAMUEL','RUANO BLANCO','Primero','BA1CM','N/A','JM','Educación Básica','0005727788');
call sp_agregarPersona2(39396,'2025438','Elián De Jesús','Sajché Sosa','Primero','BA1CM','N/A','JM','Educación Básica','0005727793');
call sp_agregarPersona2(39397,'2025226','Ovidio Alejandro','Sandoval Hernández','Primero','BA1CM','N/A','JM','Educación Básica','0007295205');
call sp_agregarPersona2(39398,'2025143','Michael Alexander','Silva Aguilar','Primero','BA1CM','N/A','JM','Educación Básica','0005756261');
call sp_agregarPersona2(39399,'2025147','Esdras Rafael','Tello López','Primero','BA1CM','N/A','JM','Educación Básica','0005756256');
call sp_agregarPersona2(39400,'2025424','Walter Rolando','Tunchez Contreras','Primero','BA1CM','N/A','JM','Educación Básica','0005712392');
call sp_agregarPersona2(39401,'2025231','Diego Sebastián','Vásquez Toc','Primero','BA1CM','N/A','JM','Educación Básica','0005712387');
call sp_agregarPersona2(39402,'2025546','Levy Benjamín','Zarceño Alvarez','Primero','BA1CM','N/A','JM','Educación Básica','0005721219');
call sp_agregarPersona2(39403,'2025402','Pablo David','Alegría Velásquez','Primero','BA1DM','N/A','JM','Educación Básica','0005721229');
call sp_agregarPersona2(39404,'2025257','Abner Jaasiel','Alvarenga Morales','Primero','BA1DM','N/A','JM','Educación Básica','0005721224');
call sp_agregarPersona2(39405,'2025023','David Fabricio','Archila Dávila','Primero','BA1DM','N/A','JM','Educación Básica','0005685093');
call sp_agregarPersona2(39406,'2025556','José Roberto','Barales Callejas','Primero','BA1DM','N/A','JM','Educación Básica','0005499226');
call sp_agregarPersona2(39407,'2025105','Gerald Andres','Brán Paz','Primero','BA1DM','N/A','JM','Educación Básica','0005685083');
call sp_agregarPersona2(39408,'2025527','Fernando Sebastián','Cermeño Aguilar','Primero','BA1DM','N/A','JM','Educación Básica','0005708821');
call sp_agregarPersona2(39409,'2025097','Sebastián','Contreras Motta','Primero','BA1DM','N/A','JM','Educación Básica','0005731926');
call sp_agregarPersona2(39410,'2025222','Dylan Samuel','Davila Lopez','Primero','BA1DM','N/A','JM','Educación Básica','0005731921');
call sp_agregarPersona2(39411,'2025423','Gerber Valdemar','del Cid Osorio','Primero','BA1DM','N/A','JM','Educación Básica','0005746232');
call sp_agregarPersona2(39412,'2025453','Sebastian Gabriel','Figueroa Morales','Primero','BA1DM','N/A','JM','Educación Básica','0005733353');
call sp_agregarPersona2(39413,'2025024','Ari Gabriel','Gallardo Cardona','Primero','BA1DM','N/A','JM','Educación Básica','0005724926');
call sp_agregarPersona2(39414,'2025107','Andres Alejandro','Garcia Alvarado','Primero','BA1DM','N/A','JM','Educación Básica','0005733363');
call sp_agregarPersona2(39415,'2025417','Diego Alejandro','González Cruz','Primero','BA1DM','N/A','JM','Educación Básica','0005704584');
call sp_agregarPersona2(39416,'2025245','Victor Antonio','Hernández Rodríguez','Primero','BA1DM','N/A','JM','Educación Básica','0005746242');
call sp_agregarPersona2(39417,'2025254','Diego Estuardo','Hidalgo Argueta','Primero','BA1DM','N/A','JM','Educación Básica','0005746237');
call sp_agregarPersona2(39418,'2025286','Douglas Isaias','López Agustín','Primero','BA1DM','N/A','JM','Educación Básica','0005691582');
call sp_agregarPersona2(39419,'2025517','Santiago Adriel','López Noj','Primero','BA1DM','N/A','JM','Educación Básica','0008045219');
call sp_agregarPersona2(39420,'2025129','David Alejandro','Luna Pérez','Primero','BA1DM','N/A','JM','Educación Básica','0005704843');
call sp_agregarPersona2(39421,'2024340','Khristopher Antonio','Martinez Coloch','Primero','BA1DM','N/A','JM','Educación Básica','0005704838');
call sp_agregarPersona2(39422,'2025324','Santiago Emanuel','Minchez Ojeda','Primero','BA1DM','N/A','JM','Educación Básica','0005715293');
call sp_agregarPersona2(39423,'2025106','Antony Josué','Montesinos Veliz','Primero','BA1DM','N/A','JM','Educación Básica','0005715298');
call sp_agregarPersona2(39424,'2025507','Johan Rafael','Muñoz López','Primero','BA1DM','N/A','JM','Educación Básica','0005715303');
call sp_agregarPersona2(39425,'2025354','José Tomás Anderson','Ordoñez Sohom','Primero','BA1DM','N/A','JM','Educación Básica','0005670370');
call sp_agregarPersona2(39426,'2025104','Angel David','Paredes Gómez','Primero','BA1DM','N/A','JM','Educación Básica','0005670160');
call sp_agregarPersona2(39427,'2025469','Esteban André','Pérez López','Primero','BA1DM','N/A','JM','Educación Básica','0005716491');
call sp_agregarPersona2(39428,'2025386','Jonathan Gabriel','Pérez Toc','Primero','BA1DM','N/A','JM','Educación Básica','0005685470');
call sp_agregarPersona2(39429,'2025213','Sebastian Emilio Tadeo','Ramírez Marroquin','Primero','BA1DM','N/A','JM','Educación Básica','0005685465');
call sp_agregarPersona2(39430,'2025044','Crisfer Ricardo','Rios Florián','Primero','BA1DM','N/A','JM','Educación Básica','0005685460');
call sp_agregarPersona2(39431,'2025120','Giovanni Sebastian','Rosales Veliz','Primero','BA1DM','N/A','JM','Educación Básica','0005705041');
call sp_agregarPersona2(39432,'2025197','Luis Eduardo','Salazar Ixchop','Primero','BA1DM','N/A','JM','Educación Básica','0005705046');
call sp_agregarPersona2(39433,'2025565','Kevin Estuardo','Santos Estrada','Primero','BA1DM','N/A','JM','Educación Básica','0005734805');
call sp_agregarPersona2(39434,'2025406','Santiago Javier','Tahuite Monterroso','Primero','BA1DM','N/A','JM','Educación Básica','0005606952');
call sp_agregarPersona2(39435,'2025554','JOSÉ RODRIGO','TOCAY COLÓN','Primero','BA1DM','N/A','JM','Educación Básica','0005606971');
call sp_agregarPersona2(39436,'2025589','Andy Melkisidec','Torres Pellecer','Primero','BA1DM','N/A','JM','Educación Básica','0005606976');
call sp_agregarPersona2(39437,'2025240','Dominic Gael','Tunchez González','Primero','BA1DM','N/A','JM','Educación Básica','0005606981');
call sp_agregarPersona2(39438,'2025243','Juan Pablo Javier','Velasquez Garcia','Primero','BA1DM','N/A','JM','Educación Básica','0007326473');
call sp_agregarPersona2(39439,'2025246','Juan Carlos','Zelaya Ramazzini','Primero','BA1DM','N/A','JM','Educación Básica','0007297634');
call sp_agregarPersona2(39440,'2025518','Anthony Donato','Alfaro Maldonado','Primero','BA1EM','N/A','JM','Educación Básica','0007312161');
call sp_agregarPersona2(39441,'2025367','Gerson Enrique','Alvarez Hernandez','Primero','BA1EM','N/A','JM','Educación Básica','0007273337');
call sp_agregarPersona2(39442,'2025217','Josehp Daniel','Argueta Lopez','Primero','BA1EM','N/A','JM','Educación Básica','0007246777');
call sp_agregarPersona2(39443,'2025557','Emanuel Enrique','Barrera Calderon','Primero','BA1EM','N/A','JM','Educación Básica','0007244374');
call sp_agregarPersona2(39444,'2025225','GERARDO ALONSO','BUSTAMANTE CHAVARRIA','Primero','BA1EM','N/A','JM','Educación Básica','0007259473');
call sp_agregarPersona2(39445,'2025112','Andrée de Jesús','Cervantes Paredes','Primero','BA1EM','N/A','JM','Educación Básica','0007290023');
call sp_agregarPersona2(39446,'2025256','Kenssel Aaron','Coque Perez','Primero','BA1EM','N/A','JM','Educación Básica','0005498444');
call sp_agregarPersona2(39447,'2025521','DIEGO ALEJANDRO','DE LEÓN MORALES','Primero','BA1EM','N/A','JM','Educación Básica','0005498437');
call sp_agregarPersona2(39448,'2025532','Jhosthyn de Jesús','Duarte Quina','Primero','BA1EM','N/A','JM','Educación Básica','0005500603');
call sp_agregarPersona2(39449,'2025362','Javier Emanuel','Flores Garrido','Primero','BA1EM','N/A','JM','Educación Básica','0007252627');
call sp_agregarPersona2(39450,'2025110','Énrick Alejandro Yulian','García Aroche','Primero','BA1EM','N/A','JM','Educación Básica','0005488831');
call sp_agregarPersona2(39451,'2025302','Daniel Sebastian','Gonzalez Gutierrez','Primero','BA1EM','N/A','JM','Educación Básica','0005488838');
call sp_agregarPersona2(39452,'2025251','Gabriel Alejandro','Ixchop Sian','Primero','BA1EM','N/A','JM','Educación Básica','0005488841');
call sp_agregarPersona2(39453,'2025399','Brayan Emanuel','Ixcol Ulario','Primero','BA1EM','N/A','JM','Educación Básica','0005494549');
call sp_agregarPersona2(39454,'2025562','Ángel Leonel','López Ajucun','Primero','BA1EM','N/A','JM','Educación Básica','0005494556');
call sp_agregarPersona2(39455,'2025206','Julio Josecarlo','Loyo Cermeño','Primero','BA1EM','N/A','JM','Educación Básica','0007256950');
call sp_agregarPersona2(39456,'2025519','Brandon josue','Lutin Hernández','Primero','BA1EM','N/A','JM','Educación Básica','0007273123');
call sp_agregarPersona2(39457,'2025563','Edrian uziel','Matias Ardeano','Primero','BA1EM','N/A','JM','Educación Básica','0007247149');
call sp_agregarPersona2(39458,'2025509','Andres Alejandro','Monroy Rivera','Primero','BA1EM','N/A','JM','Educación Básica','0007258546');
call sp_agregarPersona2(39459,'2025530','Wiliam Alejandro','Navas De la Cruz','Primero','BA1EM','N/A','JM','Educación Básica','0007278482');
call sp_agregarPersona2(39460,'2025098','Esteban Santiago','Orellana Diaz','Primero','BA1EM','N/A','JM','Educación Básica','0007294952');
call sp_agregarPersona2(39461,'2025011','Jose Fabián','Paz Paiz','Primero','BA1EM','N/A','JM','Educación Básica','0007259450');
call sp_agregarPersona2(39462,'2025369','Joaquin Isauro','Pimentel Robles','Primero','BA1EM','N/A','JM','Educación Básica','0007304239');
call sp_agregarPersona2(39463,'2025395','Mathieu Emiliano','Pinzón Hernández','Primero','BA1EM','N/A','JM','Educación Básica','0007303188');
call sp_agregarPersona2(39464,'2025118','José Pablo','Ramirez Pineda','Primero','BA1EM','N/A','JM','Educación Básica','0007291862');
call sp_agregarPersona2(39465,'2025317','Pablo Gabriel','Rivas Santizo','Primero','BA1EM','N/A','JM','Educación Básica','0007264955');
call sp_agregarPersona2(39466,'2025223','Diego Fabián','Rosas Mansilla','Primero','BA1EM','N/A','JM','Educación Básica','0007302050');
call sp_agregarPersona2(39467,'2025465','Dante Xavier','Salazar Mejía','Primero','BA1EM','N/A','JM','Educación Básica','0007267293');
call sp_agregarPersona2(39468,'2025591','Christian Josue','Selen Lopez','Primero','BA1EM','N/A','JM','Educación Básica','0007320896');
call sp_agregarPersona2(39469,'2025573','Santiago Natanael','Solorzano Mendoza','Primero','BA1EM','N/A','JM','Educación Básica','0007310542');
call sp_agregarPersona2(39470,'2025505','Sergio Rolando','Tercero Poroj','Primero','BA1EM','N/A','JM','Educación Básica','0007288546');
call sp_agregarPersona2(39471,'2025535','Pablo André','Torres Montenegro','Primero','BA1EM','N/A','JM','Educación Básica','0007273946');
call sp_agregarPersona2(39472,'2025215','Xavier Giovanni','Tux Morales','Primero','BA1EM','N/A','JM','Educación Básica','0005672569');
call sp_agregarPersona2(39473,'2025559','Tomas','Ventura Saquic','Primero','BA1EM','N/A','JM','Educación Básica','0007278056');
call sp_agregarPersona2(39474,'2025409','Jeremy Sebastián','Zetino Soto','Primero','BA1EM','N/A','JM','Educación Básica','0007315666');
call sp_agregarPersona2(39475,'2025539','Tarek Yasar','Alfaro Santos','Primero','BA1FM','N/A','JM','Educación Básica','0007295842');
call sp_agregarPersona2(39476,'2025311','Evann Sebastián','Alvarez Herrera','Primero','BA1FM','N/A','JM','Educación Básica','0005479322');
call sp_agregarPersona2(39477,'2025334','Jhuliann Oscar Matias','Arrue Cruz','Primero','BA1FM','N/A','JM','Educación Básica','0007264230');
call sp_agregarPersona2(39478,'2025461','Santiago Roberto','Caal González','Primero','BA1FM','N/A','JM','Educación Básica','0007265638');
call sp_agregarPersona2(39479,'2025332','David Andre','Cabrera Santizo','Primero','BA1FM','N/A','JM','Educación Básica','0007307590');
call sp_agregarPersona2(39480,'2025468','José Jorge','Chávez López','Primero','BA1FM','N/A','JM','Educación Básica','0007285659');
call sp_agregarPersona2(39481,'2025006','Cristopher Daniel','Cruz Ceballos','Primero','BA1FM','N/A','JM','Educación Básica','0007267481');
call sp_agregarPersona2(39482,'2025357','Daniel Esteban','Cuc Andrade','Primero','BA1FM','N/A','JM','Educación Básica','0007273131');
call sp_agregarPersona2(39483,'2025442','Rodrigo Andres','Duarte Seb','Primero','BA1FM','N/A','JM','Educación Básica','0007321292');
call sp_agregarPersona2(39484,'2025571','Javier Alexander','Echeverría Valle','Primero','BA1FM','N/A','JM','Educación Básica','0007308675');
call sp_agregarPersona2(39485,'2025133','Ojani Abdiel Ronaldo','Francisco Cordero','Primero','BA1FM','N/A','JM','Educación Básica','0007290328');
call sp_agregarPersona2(39486,'2025525','Sebastian Eduardo','García de León','Primero','BA1FM','N/A','JM','Educación Básica','0007259548');
call sp_agregarPersona2(39487,'2025472','Jhostin Steev','Gómez Cun','Primero','BA1FM','N/A','JM','Educación Básica','0007260368');
call sp_agregarPersona2(39488,'2025590','Angel Samuel','González Coguox','Primero','BA1FM','N/A','JM','Educación Básica','0007292249');
call sp_agregarPersona2(39489,'2024546','Juan de Dios','González-Campo Ramírez','Primero','BA1FM','N/A','JM','Educación Básica','0007259820');
call sp_agregarPersona2(39490,'2025487','Angello Andrée','Izeppi Quiroa','Primero','BA1FM','N/A','JM','Educación Básica','0007260094');
call sp_agregarPersona2(39491,'2025516','Héctor Gabriel','Jiménez Izaguirre','Primero','BA1FM','N/A','JM','Educación Básica','0007288290');
call sp_agregarPersona2(39492,'2025366','Angel David','López Gregorio','Primero','BA1FM','N/A','JM','Educación Básica','0007293708');
call sp_agregarPersona2(39493,'2025446','Ian Sebastián','Lutin Valdez','Primero','BA1FM','N/A','JM','Educación Básica','0007311697');
call sp_agregarPersona2(39494,'2025123','Luis Pablo','Maldonado Ajquejay','Primero','BA1FM','N/A','JM','Educación Básica','0007321099');
call sp_agregarPersona2(39495,'2025058','Ian Gabriel','Mazariegos Castillo','Primero','BA1FM','N/A','JM','Educación Básica','0007308702');
call sp_agregarPersona2(39496,'2025053','David Fernando','Morales Calderón','Primero','BA1FM','N/A','JM','Educación Básica','0007320631');
call sp_agregarPersona2(39497,'2025533','Jose Carlos','Morales Gramajo','Primero','BA1FM','N/A','JM','Educación Básica','0007310535');
call sp_agregarPersona2(39498,'2025284','Stephen José','Nij Castillo','Primero','BA1FM','N/A','JM','Educación Básica','0007247989');
call sp_agregarPersona2(39499,'2025359','Daniel Obed','Ortega Sosa','Primero','BA1FM','N/A','JM','Educación Básica','0005682323');
call sp_agregarPersona2(39500,'2025214','TOMMY DIEGO FERNANDO','PÉREZ CARIAS','Primero','BA1FM','N/A','JM','Educación Básica','0007274728');
call sp_agregarPersona2(39501,'2025441','Emilio Alejandro','Policarpio Garcia','Primero','BA1FM','N/A','JM','Educación Básica','0007258910');
call sp_agregarPersona2(39502,'2025523','Jamiltón Alexander','Puác Morales','Primero','BA1FM','N/A','JM','Educación Básica','0007256902');
call sp_agregarPersona2(39503,'2025005','Yerik André','Ramírez Quiacaín','Primero','BA1FM','N/A','JM','Educación Básica','0007260322');
call sp_agregarPersona2(39504,'2025394','Marcos Gustavo','Rodríguez Macario','Primero','BA1FM','N/A','JM','Educación Básica','0007283338');
call sp_agregarPersona2(39505,'2025360','Luis Fernando','Ruiz Velasquez','Primero','BA1FM','N/A','JM','Educación Básica','0007289216');
call sp_agregarPersona2(39506,'2024113','Juan Sebastian','Sanchez Solares','Primero','BA1FM','N/A','JM','Educación Básica','0007316178');
call sp_agregarPersona2(39507,'2025388','Kenneth Samuel','Sian Castillo','Primero','BA1FM','N/A','JM','Educación Básica','0007321239');
call sp_agregarPersona2(39508,'2025131','Dominic Santiago','Terrón Alvarez','Primero','BA1FM','N/A','JM','Educación Básica','0007247632');
call sp_agregarPersona2(39509,'2025189','Angel Santiago','Trujillo Cruz','Primero','BA1FM','N/A','JM','Educación Básica','0007260837');
call sp_agregarPersona2(39510,'2024200','SANTOS MIGUEL','TZUBAN SUCUC','Primero','BA1FM','N/A','JM','Educación Básica','0007292597');
call sp_agregarPersona2(39511,'2025248','Esteban Angel Andrés','Xocop Cúmez','Primero','BA1FM','N/A','JM','Educación Básica','0007273953');
call sp_agregarPersona2(39512,'2025145','Javier Andrés','Álvarez Noj','Primero','BA1GM','N/A','JM','Educación Básica','0002744965');
call sp_agregarPersona2(39513,'2025344','Dylan Andre','Ambrocio Velasquez','Primero','BA1GM','N/A','JM','Educación Básica','0002744970');
call sp_agregarPersona2(39514,'2025494','Rómulo David','Ayala Reyes','Primero','BA1GM','N/A','JM','Educación Básica','0002744975');
call sp_agregarPersona2(39515,'2025336','Miguel Eduardo','Cáceres Sequen','Primero','BA1GM','N/A','JM','Educación Básica','0002698279');
call sp_agregarPersona2(39516,'2025534','Justin Santiago Adalberto','Cano Lima','Primero','BA1GM','N/A','JM','Educación Básica','0002698274');
call sp_agregarPersona2(39517,'2025364','LEONEL FRANCISCO','CHOC ESQUIT','Primero','BA1GM','N/A','JM','Educación Básica','0002752436');
call sp_agregarPersona2(39518,'2025443','Esteban Ignacio','Cruz Franco','Primero','BA1GM','N/A','JM','Educación Básica','0002752441');
call sp_agregarPersona2(39519,'2025375','DIEGO EMANUEL ISAAC','ESCOBAR DAVILA','Primero','BA1GM','N/A','JM','Educación Básica','0002755345');
call sp_agregarPersona2(39520,'2025009','EDGAR DANIEL','ESQUIVEL BURGOS','Primero','BA1GM','N/A','JM','Educación Básica','0002755340');
call sp_agregarPersona2(39521,'2025037','Marco Antonio','Fuentes Guerra','Primero','BA1GM','N/A','JM','Educación Básica','0002755335');
call sp_agregarPersona2(39522,'2024536','Victor Gabriel','García Navarro','Primero','BA1GM','N/A','JM','Educación Básica','0002770558');
call sp_agregarPersona2(39523,'2025447','Dereck Isaac','González Castro','Primero','BA1GM','N/A','JM','Educación Básica','0002773286');
call sp_agregarPersona2(39524,'2025401','Ethan Sebastian','Granados Pocon','Primero','BA1GM','N/A','JM','Educación Básica','0002773291');
call sp_agregarPersona2(39525,'2025103','Jeremy Luzyano','Jorge Ramirez','Primero','BA1GM','N/A','JM','Educación Básica','0002773296');
call sp_agregarPersona2(39526,'2025297','Justin Rufino Esdras','López Hernández','Primero','BA1GM','N/A','JM','Educación Básica','0002742165');
call sp_agregarPersona2(39527,'2025596','Santiago Andre','López Rivas','Primero','BA1GM','N/A','JM','Educación Básica','0002742160');
call sp_agregarPersona2(39528,'2025396','Santiago Javier','Marquez Aquino','Primero','BA1GM','N/A','JM','Educación Básica','0002754155');
call sp_agregarPersona2(39529,'2025185','Juan Manuel','Marroquín Hernández','Primero','BA1GM','N/A','JM','Educación Básica','0002754150');
call sp_agregarPersona2(39530,'2025541','Esteban Alejandro','Mazariegos Cosajay','Primero','BA1GM','N/A','JM','Educación Básica','0007311877');
call sp_agregarPersona2(39531,'2024470','Luis Eduardo','Morales Pérez','Primero','BA1GM','N/A','JM','Educación Básica','0007303412');
call sp_agregarPersona2(39532,'2025345','Derek Zahíd','Olayo Nuñez','Primero','BA1GM','N/A','JM','Educación Básica','0007293361');
call sp_agregarPersona2(39533,'2025212','Ian Manuel','Paz Alberto','Primero','BA1GM','N/A','JM','Educación Básica','0007269891');
call sp_agregarPersona2(39534,'2025276','ANTONI RICARDO','PÉREZ GONZÁLEZ','Primero','BA1GM','N/A','JM','Educación Básica','0007313991');
call sp_agregarPersona2(39535,'2025579','JORGE DAVID','PICO MORATAYA','Primero','BA1GM','N/A','JM','Educación Básica','0005569302');
call sp_agregarPersona2(39536,'2025036','Rodrigo Sebastian','Porón Barrientos','Primero','BA1GM','N/A','JM','Educación Básica','0005569307');
call sp_agregarPersona2(39537,'2025467','Angel Natanael','Ramirez Chet','Primero','BA1GM','N/A','JM','Educación Básica','0005569312');
call sp_agregarPersona2(39538,'2025121','Derian Benjamín','Ramos Cristal','Primero','BA1GM','N/A','JM','Educación Básica','0005569256');
call sp_agregarPersona2(39539,'2025263','Carlos Josué','Román Duarte','Primero','BA1GM','N/A','JM','Educación Básica','0005569262');
call sp_agregarPersona2(39540,'2025233','Erick Santiago','Saenz Azurdia','Primero','BA1GM','N/A','JM','Educación Básica','0005500523');
call sp_agregarPersona2(39541,'2025271','Kendry David','Santiago estrada','Primero','BA1GM','N/A','JM','Educación Básica','0005500520');
call sp_agregarPersona2(39542,'2025237','Kevin Gabriel','Soberanis López','Primero','BA1GM','N/A','JM','Educación Básica','0005500513');
call sp_agregarPersona2(39543,'2025412','FERNANDO JOSUE','TINIGUAR SOTZ','Primero','BA1GM','N/A','JM','Educación Básica','0005508553');
call sp_agregarPersona2(39544,'2025250','Marcos Benjamín','Urias Barrientos','Primero','BA1GM','N/A','JM','Educación Básica','0005508546');
call sp_agregarPersona2(39545,'2025255','Benjamin Adolfo','Valey Solís','Primero','BA1GM','N/A','JM','Educación Básica','0005508532');
call sp_agregarPersona2(39546,'2025330','Gabriel Alfonso','Xajap Reyes','Primero','BA1GM','N/A','JM','Educación Básica','0005508525');
call sp_agregarPersona2(39547,'2024524','Gabriel Alberto','Bolaños López','Segundo','BA2AM','N/A','JM','Educación Básica','0091096144');
call sp_agregarPersona2(39548,'2024174','Dylan Jean Carlo','Cifuentes Barillas','Segundo','BA2AM','N/A','JM','Educación Básica','0005001546');
call sp_agregarPersona2(39549,'2024289','Maynor Homero','Hernández Lux','Segundo','BA2AM','N/A','JM','Educación Básica','0001492769');
call sp_agregarPersona2(39550,'2024385','Wilson David Alejandro','Oxlaj Sicá','Segundo','BA2AM','N/A','JM','Educación Básica','0007409121');
call sp_agregarPersona2(39551,'2024129','Sebastián Alejandro','Cano Quiñónez','Segundo','BA2BM','N/A','JM','Educación Básica','0001451586');
call sp_agregarPersona2(39552,'2024169','Ethan Dorian','López Román','Segundo','BA2BM','N/A','JM','Educación Básica','0006683657');
call sp_agregarPersona2(39553,'2024474','Jose Andres','Tun Lopez','Segundo','BA2BM','N/A','JM','Educación Básica','0005596191');
call sp_agregarPersona2(39554,'2024361','Elkin Lizandro Daniel','Gómez Hernández','Segundo','BA2CM','N/A','JM','Educación Básica','0090518593');
call sp_agregarPersona2(39555,'2024463','Diego Javier','Melgar Bran','Segundo','BA2DM','N/A','JM','Educación Básica','0006447420');
call sp_agregarPersona2(39556,'2024183','Joel Santiago','Huit Huit','Segundo','BA2DM','N/A','JM','Educación Básica','0006686180');
call sp_agregarPersona2(39557,'2024390','Javier Alfredo','Gallardo Pérez','Segundo','BA2DM','N/A','JM','Educación Básica','0090542922');
call sp_agregarPersona2(39558,'2024309','HÉCTOR MOISES','Barrera OSORIO','Segundo','BA2DM','N/A','JM','Educación Básica','0005404407');
call sp_agregarPersona2(39559,'2024533','Pablo Noe','Zapeta Raguex','Segundo','BA2EM','N/A','JM','Educación Básica','0091069482');
call sp_agregarPersona2(39560,'2024414','Luis Augusto','Méndez Godinez','Segundo','BA2EM','N/A','JM','Educación Básica','0091086108');
call sp_agregarPersona2(39561,'2024290','JOSTIN ALEJANDRO','ALVARADO LÓPEZ','Segundo','BA2EM','N/A','JM','Educación Básica','0091086722');
call sp_agregarPersona2(39562,'2025569','Kevin Ismael','Garcia Ajanel','Primero','BA1EM','N/A','JM','Educación Básica','0005499219');
call sp_agregarPersona2(39563,'2023298','Santiago Leonel','Gaytán Pineda','Tercero','BA3AM','N/A','JM','Educación Básica','0002773292');
call sp_agregarPersona2(39564,'2023506','Christopher José','Fuentes Juracán','Tercero','BA3BM','N/A','JM','Educación Básica','0007858591');
call sp_agregarPersona2(39565,'2024352','Jonathan Misael','Vicente Itzep','Cuarto ','BA3BM','N/A','JM','Mecánica Automotriz','0007314864');
call sp_agregarPersona2(39566,'2023177','Hans Donovan','Tzoc Rosales','Tercero','BA3BM','N/A','JM','Educación Básica','0007276605');
call sp_agregarPersona2(39567,'2023275','Marco vinicio','Ramirez Alvarez','Tercero','BA3BM','N/A','JM','Educación Básica','0005500503');
call sp_agregarPersona2(39568,'2023082','Félix Rodrigo','López Urizar','Tercero','BA3BM','N/A','JM','Educación Básica','0005559620');
call sp_agregarPersona2(39569,'2023258','Dereck Alejandro','Nimatuj Guerra','Tercero','BA3CM','N/A','JM','Educación Básica','0090514561');
call sp_agregarPersona2(39570,'2023215','César Isaac','Aguirre Padilla','Tercero','BA3CM','N/A','JM','Educación Básica','0007309242');
call sp_agregarPersona2(39571,'2023562','José Francisco','Quixtan Quexel','Tercero','BA3DM','N/A','JM','Educación Básica','0091099391');
call sp_agregarPersona2(39572,'2023564','Ronald Francisco','Pico Morataya','Tercero','BA3DM','N/A','JM','Educación Básica','0007277746');
call sp_agregarPersona2(39573,'2023542','Gabriel Estuardo','Iquique Mérida','Tercero','BA3DM','N/A','JM','Educación Básica','0090532506');
call sp_agregarPersona2(39574,'2023546','Angel Aaron','Contreras Girón','Tercero','BA3DM','N/A','JM','Educación Básica','0001637369');
call sp_agregarPersona2(39575,'2022371','Angel David','Zapeta Raguex','Tercero','BA3EM','N/A','JM','Educación Básica','0005441805');
call sp_agregarPersona2(39576,'2025384','Christian Giovanni','Barahona Cruz','Cuarto ','EL4AM','PE4BM','JM','Electricidad Industrial','0007292662');
call sp_agregarPersona2(39577,'2024424','Rodrigo Sebastián','Barrera Mendizábal','Cuarto ','EL4AM','PE4BM','JM','Electricidad Industrial','0007282909');
call sp_agregarPersona2(39578,'2023274','Angel Josué','Castilla Girón','Cuarto ','EL4AM','PE4BM','JM','Electricidad Industrial','0007299491');
call sp_agregarPersona2(39579,'2022276','Oscar David','Castillo Martínez','Cuarto ','EL4AM','PE4BM','JM','Electricidad Industrial','0007244956');
call sp_agregarPersona2(39580,'2025176','Josue Sebastián','Enríquez Edelman','Cuarto ','EL4AM','PE4BM','JM','Electricidad Industrial','0007256773');
call sp_agregarPersona2(39581,'2022328','FRANCISCO LEONEL','GÓMEZ SCOTT','Cuarto ','EL4AM','PE4BM','JM','Electricidad Industrial','0007276474');
call sp_agregarPersona2(39582,'2022293','Daniel Alejandro','Gonzalez Davila','Cuarto ','EL4AM','PE4BM','JM','Electricidad Industrial','0007287015');
call sp_agregarPersona2(39583,'2025433','OMAR ALEXANDER','LÓPEZ MONROY','Cuarto ','EL4AM','PE4BM','JM','Electricidad Industrial','0007273812');
call sp_agregarPersona2(39584,'2025052','Diego Fernando','Mijangos Dominguez','Cuarto ','EL4AM','PE4BM','JM','Electricidad Industrial','0007257563');
call sp_agregarPersona2(39585,'2022265','Juan José','Morales Ruiz','Cuarto ','EL4AM','PE4BM','JM','Electricidad Industrial','0007247420');
call sp_agregarPersona2(39586,'2023540','William amilcar','Neyra Hernández','Cuarto ','EL4AM','PE4BM','JM','Electricidad Industrial','0007262969');
call sp_agregarPersona2(39587,'2025169','Kevin Daniel','Saz Méndez','Cuarto ','EL4AM','PE4BM','JM','Electricidad Industrial','0007242252');
call sp_agregarPersona2(39588,'2025440','Shander Alberto','Soto Muy','Cuarto ','EL4AM','PE4BM','JM','Electricidad Industrial','0007250349');
call sp_agregarPersona2(39589,'2025063','Mynor Giovanni','Tobar Estrada','Cuarto ','EL4AM','PE4BM','JM','Electricidad Industrial','0007243371');
call sp_agregarPersona2(39590,'2025444','Jose Pablo Neythan','Ambrocio Pinzón','Cuarto ','IN4AM','PE4AM','JM','Computación','0007313369');
call sp_agregarPersona2(39591,'2025578','Christopher Benjamin','Barillas Reyna','Cuarto ','IN4AM','PE4CM','JM','Computación','0007330596');
call sp_agregarPersona2(39592,'2025051','Brayan Ricardo','Bautista Cabrera','Cuarto ','IN4AM','PE4AM','JM','Computación','0007319891');
call sp_agregarPersona2(39593,'2023512','Javier Adrián','Cajchun Zúñiga','Cuarto ','IN4AM','PE4CM','JM','Computación','0007333289');
call sp_agregarPersona2(39594,'2022166','Diego Alejandro','De León Garcia','Cuarto ','IN4AM','PE4CM','JM','Computación','0007279947');
call sp_agregarPersona2(39595,'2025070','José Daniel','Escobar Macario','Cuarto ','IN4AM','PE4CM','JM','Computación','0007263155');
call sp_agregarPersona2(39596,'2025403','Ever Joan','Folgar Cardona','Cuarto ','IN4AM','PE4CM','JM','Computación','0007253238');
call sp_agregarPersona2(39597,'2022303','Alberto Josue Alejandro','Gálvez','Cuarto ','IN4AM','PE4CM','JM','Computación','0007268157');
call sp_agregarPersona2(39598,'2023541','Herbert Adán','García Rivera','Cuarto ','IN4AM','PE4AM','JM','Computación','0007310718');
call sp_agregarPersona2(39599,'2022075','André Paolo','García Valdéz','Cuarto ','IN4AM','PE4CM','JM','Computación','0007252767');
call sp_agregarPersona2(39600,'2025071','Diego Abraham','Girón','Cuarto ','IN4AM','PE4AM','JM','Computación','0007276936');
call sp_agregarPersona2(39601,'2022107','Rodolfo Enrique','Godinez Ramirez','Cuarto ','IN4AM','PE4CM','JM','Computación','0007284474');
call sp_agregarPersona2(39602,'2025180','Kenny Anderson','Gudiel Raguay','Cuarto ','IN4AM','PE4CM','JM','Computación','0007308632');
call sp_agregarPersona2(39603,'2022127','Taylor Fernando','Gutiérrez Melchor','Cuarto ','IN4AM','PE4AM','JM','Computación','0007292633');
call sp_agregarPersona2(39604,'2025012','Joseth Emanuel','Jax Ramirez','Cuarto ','IN4AM','PE4AM','JM','Computación','0007279683');
call sp_agregarPersona2(39605,'2021464','Henry Abdiel','Lima de leon','Cuarto ','IN4AM','PE4AM','JM','Computación','0007296677');
call sp_agregarPersona2(39606,'2021325','Cristopher Giovanni','López Díaz','Cuarto ','IN4AM','PE4AM','JM','Dibujo Técnico','0007309809');
call sp_agregarPersona2(39607,'2022447','Cristian Rolando','Manuel Montepeque','Cuarto ','IN4AM','PE4CM','JM','Computación','0007252544');
call sp_agregarPersona2(39608,'2025061','Elías Ottoniel','Mendoza de León','Cuarto ','IN4AM','PE4AM','JM','Computación','0007268134');
call sp_agregarPersona2(39609,'2024057','Anderson Javier','Morales Lobos','Cuarto ','IN4AM','PE4CM','JM','Computación','0007271693');
call sp_agregarPersona2(39610,'2022039','Jadiel André','Morales Orozco','Cuarto ','IN4AM','PE4CM','JM','Computación','0007254953');
call sp_agregarPersona2(39611,'2025050','Eduardo Emilio','Palencia Mejia','Cuarto ','IN4AM','PE4CM','JM','Computación','0007318751');
call sp_agregarPersona2(39612,'2022016','Angel Alexander','Pérez Barrera','Cuarto ','EB4BM','PE4EM','JM','Computación','0007281043');
call sp_agregarPersona2(39613,'2022187','Gahel Emiliano','Rodríguez Albeño','Cuarto ','IN4AM','PE4AM','JM','Computación','0007328568');
call sp_agregarPersona2(39614,'2025017','Esteban David','Ruano Guatemala','Cuarto ','IN4AM','PE4AM','JM','Computación','0007275130');
call sp_agregarPersona2(39615,'2025135','Jesús Enrique','Sánchez Marroquín','Cuarto ','IN4AM','PE4CM','JM','Computación','0007270979');
call sp_agregarPersona2(39616,'2025020','Saymon Luis Fernando','Santos Alvarez','Cuarto ','IN4AM','PE4CM','JM','Computación','0007306432');
call sp_agregarPersona2(39617,'2025178','Jefferson Julian','Soloman Juarez','Cuarto ','IN4AM','PE4AM','JM','Computación','0005526614');
call sp_agregarPersona2(39618,'2025127','Diego Alejandro','Urrutia Garcia','Cuarto ','IN4AM','PE4AM','JM','Computación','0007332673');
call sp_agregarPersona2(39619,'2025014','Ludwing Iván','Vásquez Navas','Cuarto ','IN4AM','PE4CM','JM','Computación','0008020505');
call sp_agregarPersona2(39620,'2025076','Ángel Antonio','Aquino Canté','Cuarto ','IN4BM','PE4DM','JM','Computación','0007293598');
call sp_agregarPersona2(39621,'2025171','Jeremy Alexander','Aquino Ochoa','Cuarto ','IN4BM','PE4DM','JM','Computación','0005498436');
call sp_agregarPersona2(39622,'2025075','Carlos Emilio','Barahona Pasán','Cuarto ','IN4BM','PE4EM','JM','Computación','0005498435');
call sp_agregarPersona2(39623,'2025117','Juan Pablo Ricardo','Boj Tunche','Cuarto ','IN4BM','PE4EM','JM','Computación','0007243414');
call sp_agregarPersona2(39624,'2025086','KENNETH XAVIER','CANEDA TRUJILLO','Cuarto ','IN4BM','PE4BM','JM','Computación','0005500611');
call sp_agregarPersona2(39625,'2025161','Jose Angel','Coy Mucia','Cuarto ','IN4BM','PE4DM','JM','Computación','0005488830');
call sp_agregarPersona2(39626,'2025114','Ernesto Dalessandro','De la Rosa Santos','Cuarto ','IN4BM','PE4DM','JM','Computación','0005488839');
call sp_agregarPersona2(39627,'2025122','Hansel Antonio','Garcia Gutierrez','Cuarto ','IN4BM','PE4BM','JM','Computación','0005488840');
call sp_agregarPersona2(39628,'2025261','Angel Esteban','García Jiménez','Cuarto ','IN4BM','PE4EM','JM','Computación','0005489068');
call sp_agregarPersona2(39629,'2025164','Geyner Adryan','Gomez Jimenez','Cuarto ','IN4BM','PE4EM','JM','Computación','0005494557');
call sp_agregarPersona2(39630,'2022031','EDDER ANTONIO','GONZÁLEZ GARCÍA','Cuarto ','IN4BM','PE4DM','JM','Computación','0007303719');
call sp_agregarPersona2(39631,'2025095','Mario Roberto','Hernández García','Cuarto ','IN4BM','PE4BM','JM','Computación','0007278892');
call sp_agregarPersona2(39632,'2022010','JONATHAN XAVIER','HERNANDEZ HERNANDEZ','Cuarto ','IN4BM','PE4EM','JM','Computación','0007264627');
call sp_agregarPersona2(39633,'2024330','David Estuardo','Lacayo Morataya','Cuarto ','IN4BM','PE4EM','JM','Computación','0005567982');
call sp_agregarPersona2(39634,'2021288','Xavier Fernando','Lara Balcázar','Cuarto ','IN4BM','PE4EM','JM','Computación','0005567909');
call sp_agregarPersona2(39635,'2023297','Esteban José','Maldonado López','Cuarto ','IN4BM','PE4EM','JM','Computación','0005568061');
call sp_agregarPersona2(39636,'2025027','Kevin Eduardo','Morales Solís','Cuarto ','IN4BM','PE4EM','JM','Computación','0005568066');
call sp_agregarPersona2(39637,'2025042','Ángel Luciano','Muñoz Ruano','Cuarto ','IN4BM','PE4EM','JM','Computación','0005567937');
call sp_agregarPersona2(39638,'2025039','Alexander','Noh González','Cuarto ','IN4BM','PE4BM','JM','Computación','0005508568');
call sp_agregarPersona2(39639,'2022002','Andric Josue','Ordoñez Castillo','Cuarto ','IN4BM','PE4DM','JM','Computación','0005508563');
call sp_agregarPersona2(39640,'2022116','Brandon Leonel','Orellana Baján','Cuarto ','IN4BM','PE4BM','JM','Computación','0005508558');
call sp_agregarPersona2(39641,'2022161','Humberto Alessandro','Pérez González','Cuarto ','IN4BM','PE4DM','JM','Computación','0005500685');
call sp_agregarPersona2(39642,'2025162','Jancarlo Antonio','Ramos López','Cuarto ','IN4BM','PE4BM','JM','Computación','0005543031');
call sp_agregarPersona2(39643,'2025522','Sebastián Alejandro','Santiago Monterroso','Cuarto ','IN4BM','PE4BM','JM','Computación','0005543026');
call sp_agregarPersona2(39644,'2025040','Marcos Eriberto','Santos Ramírez','Cuarto ','IN4BM','PE4DM','JM','Computación','0005526620');
call sp_agregarPersona2(39645,'2022281','Dennis Yared','Sierra Perez','Cuarto ','IN4BM','PE4EM','JM','Computación','0005526625');
call sp_agregarPersona2(39646,'2022029','Luis Ronaldo','Valdizón Contreras','Cuarto ','IN4BM','PE4EM','JM','Computación','0005526630');
call sp_agregarPersona2(39647,'2022242','André Emanuel','Yoj Gómez','Cuarto ','IN4BM','PE4BM','JM','Computación','0005529575');
call sp_agregarPersona2(39648,'2022352','Yoel Abdí Zaker','Ambrosio Quinteros','Cuarto ','EB4AM','PE4AM','JM','Electrónica Industrial','0007325617');
call sp_agregarPersona2(39649,'2022189','Jose Carlos','Barrientos cordón','Cuarto ','EB4AM','PE4CM','JM','Electrónica básica','0007243092');
call sp_agregarPersona2(39650,'2023225','Jonatan Neftali','Batz Aquino','Cuarto ','EB4AM','PE4AM','JM','Electrónica básica','0007250314');
call sp_agregarPersona2(39651,'2025084','Fernando Leonel','Bautista Castellanos','Cuarto ','EB4AM','PE4AM','JM','Electrónica básica','0007296894');
call sp_agregarPersona2(39652,'2022342','José Pablo','Chicoj Bolaños','Cuarto ','EB4AM','PE4CM','JM','Electrónica básica','0007326954');
call sp_agregarPersona2(39653,'2025268','Alan Ivan','Colindres Luna','Cuarto ','EB4AM','PE4CM','JM','No Asignado','0007334377');
call sp_agregarPersona2(39654,'2022153','Josemaria','Díaz Hernández','Cuarto ','EB4AM','PE4AM','JM','Electrónica básica','0007249327');
call sp_agregarPersona2(39655,'2025149','Emilio Alejandro','Esquivel Noriega','Cuarto ','EB4AM','PE4CM','JM','Electrónica básica','0007273940');
call sp_agregarPersona2(39656,'2022452','Joaquin Josue','Galindo Diaz','Cuarto ','EB4AM','PE4AM','JM','Electrónica básica','0007285240');
call sp_agregarPersona2(39657,'2024297','Carlos Alejandro','Garcia Lopez','Cuarto ','EB4AM','PE4CM','JM','Electrónica básica','0007246729');
call sp_agregarPersona2(39658,'2022128','Jose Emilio','González Reyes','Cuarto ','EB4AM','PE4CM','JM','Electrónica básica','0007246409');
call sp_agregarPersona2(39659,'2025096','ALVARO DANIEL','HERNANDEZ CASTILLO','Cuarto ','EB4AM','PE4AM','JM','Electrónica básica','0007303453');
call sp_agregarPersona2(39660,'2025028','Anderson Daniel','Herrera Pacheco','Cuarto ','EB4AM','PE4CM','JM','Electrónica básica','0007326519');
call sp_agregarPersona2(39661,'2022511','Roman Eduardo','López Chacón','Cuarto ','EB4AM','PE4CM','JM','Electrónica básica','0007293404');
call sp_agregarPersona2(39662,'2025296','Martín Elison Orlando','López Hernández','Cuarto ','EB4AM','PE4AM','JM','Electrónica básica','0007305822');
call sp_agregarPersona2(39663,'2025065','ANTHONY DUBÁN','LÓPEZ POITÁN','Cuarto ','EB4AM','PE4CM','JM','Electrónica básica','0007324815');
call sp_agregarPersona2(39664,'2025016','Rony Fernando','López Suárez','Cuarto ','EB4AM','PE4CM','JM','Electrónica básica','0007242202');
call sp_agregarPersona2(39665,'2025067','Jefferson Steven','Macz Gonzales','Cuarto ','EB4AM','PE4AM','JM','Electrónica básica','0007270198');
call sp_agregarPersona2(39666,'2025170','José Pablo','Pérez Aguilar','Cuarto ','EB4AM','PE4CM','JM','Electrónica básica','0007256491');
call sp_agregarPersona2(39667,'2025308','Jeremy Jesús','Pernillo Sarceño','Cuarto ','EB4AM','PE4AM','JM','Electrónica básica','0007244043');
call sp_agregarPersona2(39668,'2025038','Andersson José Luis','Ramirez chay','Cuarto ','EB4AM','PE4CM','JM','Electrónica básica','0007276469');
call sp_agregarPersona2(39669,'2023064','Luibov Ibrahim','Ramírez Quiacaín','Cuarto ','EB4AM','PE4AM','JM','Electrónica básica','0007245934');
call sp_agregarPersona2(39670,'2025156','Edgar Guillermo Miguel','Ramos Hernandez','Cuarto ','EB4AM','PE4AM','JM','Electrónica básica','0007326264');
call sp_agregarPersona2(39671,'2025279','Diego Alexander','Revolorio Morales','Cuarto ','EB4AM','PE4CM','JM','Electrónica básica','0007242768');
call sp_agregarPersona2(39672,'2025204','Gabriel Estuardo','Solis cali','Cuarto ','EB4AM','PE4AM','JM','Electrónica básica','0007251016');
call sp_agregarPersona2(39673,'2023525','Dylan Sebastián','Taguite Chocon','Cuarto ','EB4AM','PE4AM','JM','Electrónica básica','0007244941');
call sp_agregarPersona2(39674,'2025132','Isaías Isaac','Tojin García','Cuarto ','EB4AM','PE4AM','JM','Electrónica básica','0007245102');
call sp_agregarPersona2(39675,'2022268','Oscar Alfredo','Urbina Marquez','Cuarto ','EB4AM','PE4AM','JM','Electrónica básica','0007277633');
call sp_agregarPersona2(39676,'2025348','Francisco','Vallejo Ramírez','Cuarto ','EB4AM','PE4AM','JM','Electrónica básica','0007261358');
call sp_agregarPersona2(39677,'2025079','Andy Joseba Miroslav','Zárate Pérez','Cuarto ','EB4AM','PE4CM','JM','Electrónica básica','0007329332');
call sp_agregarPersona2(39678,'2025267','Daniel Isaí','Aldana Arrecis','Cuarto ','EB4BM','PE4EM','JM','Electrónica básica','0007331503');
call sp_agregarPersona2(39679,'2022310','Gabriel Alejandro','Arrecis Vargas','Cuarto ','EB4BM','PE4DM','JM','Electrónica básica','0007317677');
call sp_agregarPersona2(39680,'2025029','José Carlos','Avila Mucía','Cuarto ','EB4BM','PE4EM','JM','Electrónica básica','0007262889');
call sp_agregarPersona2(39681,'2025260','Ian','Briones Reyes','Cuarto ','EB4BM','PE4DM','JM','Electrónica básica','0007296320');
call sp_agregarPersona2(39682,'2022290','Alexander Emmanuel','Caal Estrada','Cuarto ','EB4BM','PE4DM','JM','Electrónica básica','0007280025');
call sp_agregarPersona2(39683,'2025429','Jexel Javier','Cante Ruiz','Cuarto ','EB4BM','PE4DM','JM','Electrónica básica','0007291697');
call sp_agregarPersona2(39684,'2025085','Luis Angel','Contreras Tunchez','Cuarto ','EB4BM','PE4EM','JM','Electrónica básica','0007268309');
call sp_agregarPersona2(39685,'2025203','Fredy Javier','DAVILA Arevalo','Cuarto ','EB4BM','PE4EM','JM','Electrónica básica','0007320700');
call sp_agregarPersona2(39686,'2025172','César Raúl','Dávila Lòpez','Cuarto ','EB4BM','PE4EM','JM','Electrónica básica','0007299283');
call sp_agregarPersona2(39687,'2025158','Lían Jaydeb','De León Monterroso','Cuarto ','EB4BM','PE4EM','JM','Electrónica básica','0007273395');
call sp_agregarPersona2(39688,'2025299','Rudy Alexander','Escobar Velasquez','Cuarto ','EB4BM','PE4BM','JM','Electrónica básica','0007334498');
call sp_agregarPersona2(39689,'2022100','Pedro Xavier','Gamarro Castillo','Cuarto ','EB4BM','PE4EM','JM','Electrónica básica','0007305228');
call sp_agregarPersona2(39690,'2021137','Dante Nicolás','Gonzalez Rivas','Cuarto ','EB4BM','PE4EM','JM','Electrónica básica','0007298342');
call sp_agregarPersona2(39691,'2025126','Ethan Eduardo','González Pineda','Cuarto ','EB4BM','PE4EM','JM','Electrónica básica','0007332042');
call sp_agregarPersona2(39692,'2025146','Christopher Leonel','Gramajo Jimenez','Cuarto ','EB4BM','PE4DM','JM','Electrónica básica','0007332416');
call sp_agregarPersona2(39693,'2025209','Edwin Santiago','Hernández Chic','Cuarto ','EB4BM','PE4BM','JM','Electrónica básica','0007320181');
call sp_agregarPersona2(39694,'2025289','Miguel Romualdo','Jerónimo Velasquez','Cuarto ','EB4BM','PE4DM','JM','Electrónica básica','0007255863');
call sp_agregarPersona2(39695,'2025303','Joshua Abraham','Martínez Villagrán','Cuarto ','EB4BM','PE4DM','JM','Electrónica básica','0007320856');
call sp_agregarPersona2(39696,'2022257','José Fernando','Mazariegos López','Cuarto ','EB4BM','PE4BM','JM','Electrónica básica','0007300801');
call sp_agregarPersona2(39697,'2025154','Abraham Rosmel Yosef','Maldonado Monterroso','Cuarto ','EB4BM','PE4BM','JM','Electrónica básica','0007319258');
call sp_agregarPersona2(39698,'2025026','PEDRO PABLO','MOLINA FIGUEROA','Cuarto ','EB4BM','PE4BM','JM','Electrónica básica','0007288965');
call sp_agregarPersona2(39699,'2025371','Rafael','Montenegro García','Cuarto ','EB4BM','PE4BM','JM','Electrónica básica','0007306845');
call sp_agregarPersona2(39700,'2025015','Juan Francisco','Noj Mazariegos','Cuarto ','EB4BM','PE4DM','JM','Electrónica básica','0007244519');
call sp_agregarPersona2(39701,'2025046','Freddy alexander','Román Morales','Cuarto ','EB4BM','PE4BM','JM','Electrónica básica','0007273639');
call sp_agregarPersona2(39702,'2025340','Christopher Jose','Sagastume Vicente','Cuarto ','EB4BM','PE4DM','JM','Electrónica básica','0007321115');
call sp_agregarPersona2(39703,'2022202','Jonathan Eduardo','Tavico Us','Cuarto ','EB4BM','PE4BM','JM','Electrónica básica','0007306378');
call sp_agregarPersona2(39704,'2022160','Andrés Alejandro','Vásquez Pérez','Cuarto ','EB4BM','PE4BM','JM','Electrónica básica','0007312163');
call sp_agregarPersona2(39705,'2022295','Julio César','Almazán Rodríguez','Cuarto ','MB4AM','PE4AM','JM','Mecánica Automotriz','0007252826');
call sp_agregarPersona2(39706,'2022236','Randal Marcos Isaac','Ambrosio Coronado','Cuarto ','MB4AM','PE4CM','JM','Mecánica Automotriz','0005510397');
call sp_agregarPersona2(39707,'2025013','Cristhopher Rodrigo','Beteta Monterroso','Cuarto ','MB4AM','PE4AM','JM','Mecánica Automotriz','0005510402');
call sp_agregarPersona2(39708,'2025047','CARLOS ESTUARDO','CASTRO VILLATORO','Cuarto ','MB4AM','PE4CM','JM','Mecánica Automotriz','0005500409');
call sp_agregarPersona2(39709,'2025032','Andrés Emilio','Chiquín Navarro','Cuarto ','MB4AM','PE4CM','JM','Mecánica Automotriz','0005500414');
call sp_agregarPersona2(39710,'2025049','Esteban Jean Carlo','del Aguila Gaitán','Cuarto ','MB4AM','PE4CM','JM','Mecánica Automotriz','0005500419');
call sp_agregarPersona2(39711,'2025109','Diego Javier','Donis López','Cuarto ','MB4AM','PE4AM','JM','Mecánica Automotriz','0005488765');
call sp_agregarPersona2(39712,'2025072','Dennis Alexander','Escobar Santos','Cuarto ','MB4AM','PE4CM','JM','Mecánica Automotriz','0005488760');
call sp_agregarPersona2(39713,'2025087','Dennis Alessandro','Estrada Aldana','Cuarto ','MB4AM','PE4AM','JM','Mecánica Automotriz','0005494513');
call sp_agregarPersona2(39714,'2022446','GERARDO ANDRES','GARCÍA LÓPEZ','Cuarto ','MB4AM','PE4CM','JM','Mecánica Automotriz','0007321398');
call sp_agregarPersona2(39715,'2023153','Pablo César','Hernández Yupe','Cuarto ','MB4AM','PE4CM','JM','Mecánica Automotriz','0005479500');
call sp_agregarPersona2(39716,'2025073','Juan Diego','Ixen Teleguario','Cuarto ','MB4AM','PE4CM','JM','Mecánica Automotriz','0005479495');
call sp_agregarPersona2(39717,'2022495','Edgar Rodrigo','Lima Samuy','Cuarto ','MB4AM','PE4CM','JM','Mecánica Automotriz','0005500492');
call sp_agregarPersona2(39718,'2024454','Harold Enrique','López Serrano','Cuarto ','MB4AM','PE4AM','JM','Mecánica Automotriz','0005494542');
call sp_agregarPersona2(39719,'2025060','Vladimir de Jesús','Marroquín del Aguila.','Cuarto ','MB4AM','PE4CM','JM','Mecánica Automotriz','0005494537');
call sp_agregarPersona2(39720,'2022214','Sergio Andree','Martinez Martinez','Cuarto ','MB4AM','PE4AM','JM','Mecánica Automotriz','0005489054');
call sp_agregarPersona2(39721,'2025059','Andres Josue','Mendoza Martínez','Cuarto ','MB4AM','PE4CM','JM','Mecánica Automotriz','0005489059');
call sp_agregarPersona2(39722,'2022387','Diego Javier','Montenegro Osuna','Cuarto ','MB4AM','PE4AM','JM','Mecánica Automotriz','0005489064');
call sp_agregarPersona2(39723,'2025069','Pablo Andrés','Muñoz samayoa','Cuarto ','MB4AM','PE4CM','JM','Mecánica Automotriz','0007286823');
call sp_agregarPersona2(39724,'2023439','Johan Said','Navarete Davila','Cuarto ','MB4AM','PE4CM','JM','Mecánica Automotriz','0007272758');
call sp_agregarPersona2(39725,'2025119','NERY ALONZO','PAR TAUTIU','Cuarto ','MB4AM','PE4CM','JM','Mecánica Automotriz','0007266362');
call sp_agregarPersona2(39726,'2022034','Ricardo Andres','Pichiyá Cúmez','Cuarto ','MB4AM','PE4AM','JM','Mecánica Automotriz','0007286511');
call sp_agregarPersona2(39727,'2025174','Carlos Enrique','Picholá Peinado','Cuarto ','MB4AM','PE4CM','JM','Mecánica Automotriz','0007272458');
call sp_agregarPersona2(39728,'2023199','Lester Eduardo','Quintanilla Noj','Cuarto ','MB4AM','PE4AM','JM','Mecánica Automotriz','0007297386');
call sp_agregarPersona2(39729,'2022389','Cristofer David','Ramos Aguilar','Cuarto ','MB4AM','PE4CM','JM','Mecánica Automotriz','0007283506');
call sp_agregarPersona2(39730,'2023131','JUAN PABLO','ROSALES HERNÁNDEZ','Cuarto ','MB4AM','PE4AM','JM','Mecánica Automotriz','0007280538');
call sp_agregarPersona2(39731,'2023492','Yahird Josue Ignacio','Sirin Osorio','Cuarto ','MB4AM','PE4CM','JM','Mecánica Automotriz','0007298768');
call sp_agregarPersona2(39732,'2025080','Kenet Armando','Tzunun Mendez','Cuarto ','MB4AM','PE4AM','JM','Mecánica Automotriz','0007313795');
call sp_agregarPersona2(39733,'2022467','Malcom Damián','Velásquez Mejía','Cuarto ','MB4AM','PE4CM','JM','Mecánica Automotriz','0007256588');
call sp_agregarPersona2(39734,'2022283','Joel Francisco','Archila Dávila','Cuarto ','IN4CM','PE4EM','JM','Computación','0005529580');
call sp_agregarPersona2(39735,'2022327','Gabriel Alexander','Calderón Monzón','Cuarto ','IN4CM','PE4DM','JM','Computación','0005540838');
call sp_agregarPersona2(39736,'2021697','Marcos Bladimir','Carrion Urbina','Cuarto ','IN4CM','PE4EM','JM','Computación','0005540833');
call sp_agregarPersona2(39737,'2022510','Diego Sebastián','Cartajena Lam','Cuarto ','IN4CM','PE4EM','JM','Computación','0005540828');
call sp_agregarPersona2(39738,'2023536','Jerry Lazaron Daniel','Castro Rojas','Cuarto ','IN4CM','PE4BM','JM','Computación','0005559911');
call sp_agregarPersona2(39739,'2025089','Luis Enrique','Chac González','Cuarto ','IN4CM','PE4EM','JM','Computación','0005553449');
call sp_agregarPersona2(39740,'2024540','Luis Alejandro','Chan Ortega','Cuarto ','IN4CM','PE4DM','JM','Computación','0007283547');
call sp_agregarPersona2(39741,'2022047','Josue Gabriel','Chan Valencia','Cuarto ','IN4CM','PE4DM','JM','Computación','0005553439');
call sp_agregarPersona2(39742,'2025155','Esteban David','Chún Escobar','Cuarto ','IN4CM','PE4DM','JM','Computación','0005559646');
call sp_agregarPersona2(39743,'2025088','William David','Contreras Alvarez','Cuarto ','IN4CM','PE4DM','JM','Computación','0005479324');
call sp_agregarPersona2(39744,'2025091','Emmanuel Josué','Cuxé Tan','Cuarto ','IN4CM','PE4BM','JM','Computación','0005479329');
call sp_agregarPersona2(39745,'2025275','Wilfred Alexander','De Paz Hernandez','Cuarto ','IN4CM','PE4DM','JM','Computación','0005479334');
call sp_agregarPersona2(39746,'2025239','Eros Giancarlo','Duarte Sánchez','Cuarto ','IN4CM','PE4BM','JM','Computación','0007277852');
call sp_agregarPersona2(39747,'2021072','Fernando Eliseo','Herrarte Pulex','Cuarto ','IN4CM','PE4DM','JM','Computación','0007330264');
call sp_agregarPersona2(39748,'2022205','Josué','Jolón Motta','Cuarto ','IN4CM','PE4BM','JM','Computación','0007246899');
call sp_agregarPersona2(39749,'2025054','Kevin Alexander','Juárez Larios','Cuarto ','IN4CM','PE4BM','JM','Computación','0007291863');
call sp_agregarPersona2(39750,'2022063','Kevin Felipe Sebastián','Lancerio Castro','Cuarto ','IN4CM','PE4DM','JM','Computación','0007281232');
call sp_agregarPersona2(39751,'2025025','Edy Josue','Martinez Aguilar','Cuarto ','IN4CM','PE4BM','JM','Computación','0007281544');
call sp_agregarPersona2(39752,'2025031','Marcos Isai','Montenegro Vásquez','Cuarto ','IN4CM','PE4BM','JM','Computación','0007282477');
call sp_agregarPersona2(39753,'2025101','Josue Ricardo','Obregon Callejas','Cuarto ','IN4CM','PE4BM','JM','Computación','0007275472');
call sp_agregarPersona2(39754,'2024204','Mateo Benjamin','Ortiz de León','Cuarto ','IN4CM','PE4EM','JM','Computación','0007275761');
call sp_agregarPersona2(39755,'2022361','Angel Gabriel','Portillo Raymundo','Cuarto ','IN4CM','PE4EM','JM','Computación','0007288404');
call sp_agregarPersona2(39756,'2022275','David Enrique','Quintanilla Pérez','Cuarto ','IN4CM','PE4EM','JM','Computación','0007307295');
call sp_agregarPersona2(39757,'2025157','Domingo Alejandro','Romero Hernández','Cuarto ','IN4CM','PE4EM','JM','Computación','0007261257');
call sp_agregarPersona2(39758,'2025092','Omar Alejandro Ottoniel','Tobar De León','Cuarto ','IN4CM','PE4DM','JM','Computación','0007294832');
call sp_agregarPersona2(39759,'2021643','Rudy de Jesús','Xiquin Pérez','Cuarto ','IN4CM','PE4BM','JM','Computación','0007331154');
call sp_agregarPersona2(39760,'2025141','Efrain Andres','Callejas Mazariegos','Cuarto ','IN4CM','PE4DM','JM','Computación','0007324742');
call sp_agregarPersona2(39761,'2023251','Pablo Adrian','Santos Monroy','Cuarto ','IN4CM','PE4BM','JM','Computación','0007271592');
call sp_agregarPersona2(39762,'2025130','Pablo Alexander','Alvarado Raxón','Cuarto ','MB4BM','PE4DM','JM','Mecánica Automotriz','0007255045');
call sp_agregarPersona2(39763,'2025057','Samuel Elly','Alvarez Yat','Cuarto ','MB4BM','PE4DM','JM','Mecánica Automotriz','0005485055');
call sp_agregarPersona2(39764,'2022306','Alexis Sebástian de Jesús','Aragón Ramírez','Cuarto ','MB4BM','PE4EM','JM','Mecánica Automotriz','0005482862');
call sp_agregarPersona2(39765,'2025078','Eliú Emir','Carias Pineda','Cuarto ','MB4BM','PE4DM','JM','Mecánica Automotriz','0005482867');
call sp_agregarPersona2(39766,'2022356','Cristian Alejandro','Cervantes Paredes','Cuarto ','MB4BM','PE4EM','JM','Mecánica Automotriz','0005723754');
call sp_agregarPersona2(39767,'2025068','Francisco Ernesto','Chavez Juarez','Cuarto ','MB4BM','PE4DM','JM','Mecánica Automotriz','0005723749');
call sp_agregarPersona2(39768,'2025055','Nimrod Jeremías','Chocón Cardona','Cuarto ','MB4BM','PE4EM','JM','Mecánica Automotriz','0005667536');
call sp_agregarPersona2(39769,'2022045','Alfredd Stevenss','de León Coronado','Cuarto ','MB4BM','PE4DM','JM','Mecánica Automotriz','0007265681');
call sp_agregarPersona2(39770,'2023486','JAVIER ESTUARDO','DEL CID VELA','Cuarto ','MB4BM','PE4EM','JM','Mecánica Automotriz','0005667526');
call sp_agregarPersona2(39771,'2025034','Abner Josué','Echeverría Caál','Cuarto ','MB4BM','PE4DM','JM','Mecánica Automotriz','0005693815');
call sp_agregarPersona2(39772,'2025045','Angelo Oswaldo','Escobar Toj','Cuarto ','MB4BM','PE4EM','JM','Mecánica Automotriz','0005693814');
call sp_agregarPersona2(39773,'2022272','Diego Alejandro','Fuentes Hernández','Cuarto ','MB4BM','PE4DM','JM','Mecánica Automotriz','0005689339');
call sp_agregarPersona2(39774,'2022066','Kenneth André','Joj Castillo','Cuarto ','MB4BM','PE4EM','JM','Mecánica Automotriz','0005553441');
call sp_agregarPersona2(39775,'2025274','Javier Alexander','Jolón Pineda','Cuarto ','MB4BM','PE4DM','JM','Mecánica Automotriz','0005694123');
call sp_agregarPersona2(39776,'2022481','Emerson Rolando','Macario Suy','Cuarto ','MB4BM','PE4DM','JM','Mecánica Automotriz','0005738211');
call sp_agregarPersona2(39777,'2022048','Andres Ignacio','Martinez Ajanel','Cuarto ','MB4BM','PE4EM','JM','Mecánica Automotriz','0005738210');
call sp_agregarPersona2(39778,'2022415','Jorge David','Mejia Cordon','Cuarto ','MB4BM','PE4EM','JM','Mecánica Automotriz','0005738236');
call sp_agregarPersona2(39779,'2025314','Diego Alejandro','Mejía Noj','Cuarto ','MB4BM','PE4EM','JM','Mecánica Automotriz','0005738237');
call sp_agregarPersona2(39780,'2022119','Allan Mauricio','Miranda Espinoza','Cuarto ','MB4BM','PE4EM','JM','Mecánica Automotriz','0005738229');
call sp_agregarPersona2(39781,'2025082','Billy Daniel','Morales Paz','Cuarto ','MB4BM','PE4DM','JM','Mecánica Automotriz','0005731216');
call sp_agregarPersona2(39782,'2025019','Carlos Armando','Mux García','Cuarto ','MB4BM','PE4EM','JM','Mecánica Automotriz','0005731215');
call sp_agregarPersona2(39783,'2025021','José Javier','Ortiz Morales','Cuarto ','MB4BM','PE4DM','JM','Mecánica Automotriz','0005713875');
call sp_agregarPersona2(39784,'2022322','Héctor Ricardo','Pellecer Rodríguez','Cuarto ','MB4BM','PE4EM','JM','Mecánica Automotriz','0005713869');
call sp_agregarPersona2(39785,'2025056','Aroldo Enrique','Pinto Martínez','Cuarto ','MB4BM','PE4DM','JM','Mecánica Automotriz','0005729927');
call sp_agregarPersona2(39786,'2025030','Gustavo Moises','Pú Simón','Cuarto ','MB4BM','PE4EM','JM','Mecánica Automotriz','0008012035');
call sp_agregarPersona2(39787,'2023094','Gerardo Sebastian','Ramírez De La Crúz','Cuarto ','MB4BM','PE4DM','JM','Mecánica Automotriz','0008014097');
call sp_agregarPersona2(39788,'2025083','Jefferson Javier','Roque Rivas','Cuarto ','MB4BM','PE4EM','JM','Mecánica Automotriz','0008009070');
call sp_agregarPersona2(39789,'2021284','Cristóbal Alexander Moisés','Saquic Lux','Cuarto ','MB4BM','PE4DM','JM','Mecánica Automotriz','0007987962');
call sp_agregarPersona2(39790,'2025022','Angel Omar','Sosa Riera','Cuarto ','MB4BM','PE4EM','JM','Mecánica Automotriz','0005523225');
call sp_agregarPersona2(39791,'2025159','Hanzel Renato','Yánes Alfaro','Cuarto ','MB4BM','PE4DM','JM','Mecánica Automotriz','0007287354');
call sp_agregarPersona2(39792,'2024475','Nery Daniel','Chávez Castillo','Cuarto ','DB4AM','PE4DM','JM','Dibujo Técnico','0007274324');
call sp_agregarPersona2(39793,'2022113','Ronald Ely','Chub Pérez','Cuarto ','DB4AM','PE4DM','JM','Dibujo Técnico','0007301138');
call sp_agregarPersona2(39794,'2022319','Luis Emilio','Díaz Rivera','Cuarto ','DB4AM','PE4EM','JM','Dibujo Técnico','0007264810');
call sp_agregarPersona2(39795,'2025142','David Alexander','Duarte Torres','Cuarto ','DB4AM','PE4EM','JM','Dibujo Técnico','0007302419');
call sp_agregarPersona2(39796,'2022001','Ángel Sebastián','Farnés Olmedo','Cuarto ','DB4AM','PE4BM','JM','Dibujo Técnico','0007298864');
call sp_agregarPersona2(39797,'2025077','Marco Tulio Esteban','Flores Garcia','Cuarto ','DB4AM','PE4EM','JM','Dibujo Técnico','0007329310');
call sp_agregarPersona2(39798,'2022286','Josué David','García Barán','Cuarto ','DB4AM','PE4BM','JM','Dibujo Técnico','0007327075');
call sp_agregarPersona2(39799,'2022338','Esteban Alejandro','Garcia Morales','Cuarto ','DB4AM','PE4EM','JM','Computación','0007247092');
call sp_agregarPersona2(39800,'2022032','Victor Alejandro','Gomez de la Cruz','Cuarto ','DB4AM','PE4BM','JM','Dibujo Técnico','0007263054');
call sp_agregarPersona2(39801,'2025018','José Emanuel','Gómez Menéndez','Cuarto ','DB4AM','PE4DM','JM','Dibujo Técnico','0007261674');
call sp_agregarPersona2(39802,'2022018','Derek Alfredo','Gonzalez Calderón','Cuarto ','DB4AM','PE4DM','JM','Dibujo Técnico','0007283980');
call sp_agregarPersona2(39803,'2023553','Andre Sebastian','Guevara Rodríguez','Cuarto ','DB4AM','PE4EM','JM','Dibujo Técnico','0007266204');
call sp_agregarPersona2(39804,'2022461','Pablo Daniel','Juarez Juárez','Cuarto ','DB4AM','PE4EM','JM','Dibujo Técnico','0007264366');
call sp_agregarPersona2(39805,'2022173','Luis Hadriel','López Jocón','Cuarto ','DB4AM','PE4BM','JM','Dibujo Técnico','0007284167');
call sp_agregarPersona2(39806,'2022279','José David','Lucas Ruiz','Cuarto ','DB4AM','PE4DM','JM','Dibujo Técnico','0005633549');
call sp_agregarPersona2(39807,'2022383','ESTEBAN VINICIO','MONTERROSO CURUP','Cuarto ','DB4AM','PE4DM','JM','Dibujo Técnico','0005633556');
call sp_agregarPersona2(39808,'2022311','JOSÉ ADOLFO','MORÁN FUNES','Cuarto ','DB4AM','PE4EM','JM','Dibujo Técnico','0005625179');
call sp_agregarPersona2(39809,'2022013','José Mario','Muñoz Contreras','Cuarto ','DB4AM','PE4BM','JM','Dibujo Técnico','0005625172');
call sp_agregarPersona2(39810,'2025108','Tz´uchin Kanek','Ortiz Felipe','Cuarto ','DB4AM','PE4EM','JM','Dibujo Técnico','0007319567');
call sp_agregarPersona2(39811,'2025352','Elliot Abraham','Pedroza Briones','Cuarto ','DB4AM','PE4BM','JM','Dibujo Técnico','0007332011');
call sp_agregarPersona2(39812,'2022169','Daniel Alejandro','Pérez Alvarez','Cuarto ','DB4AM','PE4BM','JM','Dibujo Técnico','0007298344');
call sp_agregarPersona2(39813,'2022225','Bryan Alexander','Pérez Fuentes','Cuarto ','DB4AM','PE4DM','JM','Dibujo Técnico','0007313964');
call sp_agregarPersona2(39814,'2025062','Carlos Mardoqueo','Sajbin Hernández','Cuarto ','DB4AM','PE4DM','JM','Dibujo Técnico','0007327969');
call sp_agregarPersona2(39815,'2022333','Roberto Alejandro','Salvador Rodríguez','Cuarto ','DB4AM','PE4BM','JM','Dibujo Técnico','0007268724');
call sp_agregarPersona2(39816,'2025064','Elian joaquin','Sipac Toj','Cuarto ','DB4AM','PE4DM','JM','Dibujo Técnico','0007251219');
call sp_agregarPersona2(39817,'2025081','Mario Sebastian','Tan Coromac','Cuarto ','DB4AM','PE4EM','JM','Dibujo Técnico','0007243233');
call sp_agregarPersona2(39818,'2022316','Rodrigo Alexander','Tomás Cac','Cuarto ','DB4AM','PE4BM','JM','Dibujo Técnico','0007302179');
call sp_agregarPersona2(39819,'2022299','Juan Jose','Tun Lopez','Cuarto ','DB4AM','PE4DM','JM','Dibujo Técnico','0005526608');
call sp_agregarPersona2(39820,'2025125','Pablo Josué','Vaquin Bacajol','Cuarto ','DB4AM','PE4EM','JM','Dibujo Técnico','0007294260');
call sp_agregarPersona2(39821,'2025323','Ernesto Anibal','Aguilar Martinez','Cuarto ','EB4AV','PE4AV','JV','Electrónica básica','0007252142');
call sp_agregarPersona2(39822,'2025382','Edwin Johander','Alvarado Alvizuris','Cuarto ','EB4AV','PE4CV','JV','Electrónica básica','0007242020');
call sp_agregarPersona2(39823,'2025273','Fernando José','Argueta Serech','Cuarto ','EB4AV','PE4AV','JV','Electrónica básica','0004798519');
call sp_agregarPersona2(39824,'2025449','FELIPE DE JESÚS','BOR','Cuarto ','EB4AV','PE4AV','JV','Electrónica básica','0004740726');
call sp_agregarPersona2(39825,'2025567','José Eduardo','Concuá Pérez','Cuarto ','EB4AV','PE4CV','JV','Electrónica básica','0007276035');
call sp_agregarPersona2(39826,'2025574','Cristofer Abraham','Culajay Valenzuela','Cuarto ','EB4AV','PE4CV','JV','Electrónica básica','0004766534');
call sp_agregarPersona2(39827,'2025407','Juan Pablo de Jesús','González Gregorio','Cuarto ','EB4AV','PE4AV','JV','Electrónica básica','0004766544');
call sp_agregarPersona2(39828,'2025102','José Pablo','Hernández Díaz','Cuarto ','EB4AV','PE4AV','JV','Electrónica básica','0004766539');
call sp_agregarPersona2(39829,'2025421','Francisco Javier','Jiménez Ac','Cuarto ','EB4AV','PE4AV','JV','Electrónica básica','0004762095');
call sp_agregarPersona2(39830,'2025476','Alex Gabriel','Juárez Sal','Cuarto ','EB4BM','PE4BM','JM','Electrónica básica','0004762088');
call sp_agregarPersona2(39831,'2025479','Pablo Sebastian','Lopez Juarez','Cuarto ','EB4AV','PE4AV','JV','Electrónica básica','0004748111');
call sp_agregarPersona2(39832,'2025510','Olivert Emanuel','Martín Rosales','Cuarto ','EB4AV','PE4CV','JV','Electrónica básica','0004748121');
call sp_agregarPersona2(39833,'2025599','Luis Estuardo','Argueta Elias','Cuarto ','IN4BV','PE4EV','JV','Computación','0005559619');
call sp_agregarPersona2(39834,'2025506','David Alejandro','Peralta Monzon','Cuarto ','EB4AV','PE4AV','JV','Electrónica básica','0004739070');
call sp_agregarPersona2(39835,'2025483','Eder Adrian','Rivera Cuellar','Cuarto ','EB4AV','PE4CV','JV','Electrónica básica','0007290343');
call sp_agregarPersona2(39836,'2024097','Antoni Aldair','Rucal Gamboa','Cuarto ','EB4AV','PE4CV','JV','Electrónica básica','0004806229');
call sp_agregarPersona2(39837,'2025351','Cristopher Samuel','Tocorá Montealegre','Cuarto ','EB4AV','PE4AV','JV','Electrónica básica','0004806224');
call sp_agregarPersona2(39838,'2025515','DIEGO JAVIER','AJTUN SOCOY','Cuarto ','DB4AV','PE4EV','JV','Dibujo Técnico','0004762096');
call sp_agregarPersona2(39839,'2025551','Pablo Isaack','Alvarado Linares','Cuarto ','DB4AV','PE4EV','JV','Dibujo Técnico','0007263767');
call sp_agregarPersona2(39840,'2022358','Jorge Luis','Araujo Campos','Cuarto ','DB4AV','PE4BV','JV','Dibujo Técnico','0004748110');
call sp_agregarPersona2(39841,'2025293','Angel Daniel','Cabrera Hernández','Cuarto ','DB4AV','PE4DV','JV','Dibujo Técnico','0004748119');
call sp_agregarPersona2(39842,'2025425','Jairo Yair','Cal Temaj','Cuarto ','DB4AV','PE4EV','JV','Dibujo Técnico','0004748120');
call sp_agregarPersona2(39843,'2022053','José Carlos','Castro Martinez','Cuarto ','DB4AV','PE4DV','JV','Dibujo Técnico','0004739074');
call sp_agregarPersona2(39844,'2025211','Kevin Santiago','Coy Moraga','Cuarto ','DB4AV','PE4BV','JV','Dibujo Técnico','0007246739');
call sp_agregarPersona2(39845,'2025550','Iñaki Franzcisco Xavier','Espinoza Ramírez','Cuarto ','DB4AV','PE4EV','JV','Dibujo Técnico','0005511821');
call sp_agregarPersona2(39846,'2022170','Kenneth Emmanuel','García Romero','Cuarto ','DB4AV','PE4BV','JV','Dibujo Técnico','0005511826');
call sp_agregarPersona2(39847,'2025184','Paolo David','González Sicajá','Cuarto ','DB4AV','PE4BV','JV','Dibujo Técnico','0005511801');
call sp_agregarPersona2(39848,'2025540','Carlos Estuardo Rafael','Guaz Patzan','Cuarto ','DB4AV','PE4EV','JV','Dibujo Técnico','0005511805');
call sp_agregarPersona2(39849,'2025304','Javier Antonio','Herrera Carrera','Cuarto ','DB4AV','PE4DV','JV','Dibujo Técnico','0005486241');
call sp_agregarPersona2(39850,'2025484','Eddy Fernando','Herrera Salguero','Cuarto ','DB4AV','PE4EV','JV','Dibujo Técnico','0005486250');
call sp_agregarPersona2(39851,'2025313','Dilberth Antonio','Itzep López','Cuarto ','DB4AV','PE4DV','JV','Dibujo Técnico','0005500511');
call sp_agregarPersona2(39852,'2022304','Luis Fernando','Ixpata Menocal','Cuarto ','DB4AM','PE4BM','JM','Dibujo Técnico','0007327944');
call sp_agregarPersona2(39853,'2025196','Enyerson Ricardo','Linares Alarcon','Cuarto ','DB4AV','PE4EV','JV','Dibujo Técnico','0005485052');
call sp_agregarPersona2(39854,'2022266','Luis Alberto','Maldonado Avelar','Cuarto ','DB4AV','PE4DV','JV','Dibujo Técnico','0005482859');
call sp_agregarPersona2(39855,'2025486','Bryan Orlando','Oxcal Hernández','Cuarto ','DB4AV','PE4DV','JV','Dibujo Técnico','0005482853');
call sp_agregarPersona2(39856,'2025398','Oscar Mardoqueo','Pedro Cipriano','Cuarto ','DB4AV','PE4BV','JV','Dibujo Técnico','0005482843');
call sp_agregarPersona2(39857,'2025281','Saúl Andrée','Pérez Girón','Cuarto ','DB4AV','PE4DV','JV','Dibujo Técnico','0005539616');
call sp_agregarPersona2(39858,'2025266','Gustavo David','Pérez Ramos','Cuarto ','DB4AV','PE4BV','JV','Dibujo Técnico','0005495991');
call sp_agregarPersona2(39859,'2025160','Ander Diego Josué','Picholá Monroy','Cuarto ','DB4AV','PE4BV','JV','Dibujo Técnico','0005495990');
call sp_agregarPersona2(39860,'2025552','DYLAN JHOEL','TEJAXUN XUNIC','Cuarto ','DB4AV','PE4DV','JV','Dibujo Técnico','0005495981');
call sp_agregarPersona2(39861,'2025173','Cristian enrique','Tzum','Cuarto ','DB4AV','PE4BV','JV','Dibujo Técnico','0004812439');
call sp_agregarPersona2(39862,'2025192','Diego José','Velásquez Girón','Cuarto ','DB4AV','PE4EV','JV','Dibujo Técnico','0004812444');
call sp_agregarPersona2(39863,'2025191','SAUL ALEJANDRO','YANI AJIN','Cuarto ','DB4AV','PE4BV','JV','Dibujo Técnico','0004812449');
call sp_agregarPersona2(39864,'2025307','Jorge Luis','Alvarado Jolón','Cuarto ','MB4AV','PE4CV','JV','Mecánica Automotriz','0005490258');
call sp_agregarPersona2(39865,'2025355','Sean Mijahel Andrew','Alvarado Ramírez','Cuarto ','MB4AV','PE4AV','JV','Mecánica Automotriz','0007280475');
call sp_agregarPersona2(39866,'2021213','Jefferson Ariel','Back Mota','Cuarto ','MB4AV','PE4AV','JV','Mecánica Automotriz','0008024975');
call sp_agregarPersona2(39867,'2025148','Jose Daniel','Barrios Rosas','Cuarto ','MB4AV','PE4CV','JV','Mecánica Automotriz','0008058238');
call sp_agregarPersona2(39868,'2025168','Kevin Esteban','Chinchilla Donis','Cuarto ','MB4AV','PE4AV','JV','Mecánica Automotriz','0005490255');
call sp_agregarPersona2(39869,'2025190','Daniel Estuardo','Cuellar Andrés','Cuarto ','MB4AV','PE4AV','JV','Mecánica Automotriz','0005488287');
call sp_agregarPersona2(39870,'2025280','Jenner Estif','Gaitán Martínez','Cuarto ','MB4AV','PE4AV','JV','Mecánica Automotriz','0005483137');
call sp_agregarPersona2(39871,'2025294','Bryan Alexander','García Orozco','Cuarto ','MB4AV','PE4AV','JV','Mecánica Automotriz','0005483132');
call sp_agregarPersona2(39872,'2025230','Brayan Andre','González Rodriguez','Cuarto ','MB4AV','PE4AV','JV','Mecánica Automotriz','0005483123');
call sp_agregarPersona2(39873,'2025346','José Manuel','Hernández Arevalo','Cuarto ','MB4AV','PE4CV','JV','Mecánica Automotriz','0005478373');
call sp_agregarPersona2(39874,'2025220','LUIS ALEJANDRO JOSE','HERNANDEZ HERRERA','Cuarto ','MB4AV','PE4AV','JV','Mecánica Automotriz','0005478379');
call sp_agregarPersona2(39875,'2025166','Jonathan David','López Bámaca','Cuarto ','MB4AV','PE4CV','JV','Mecánica Automotriz','0005566376');
call sp_agregarPersona2(39876,'2025163','Pablo Andres','López Samayoa','Cuarto ','MB4AV','PE4CV','JV','Mecánica Automotriz','0005569483');
call sp_agregarPersona2(39877,'2025312','KEVIN ADRIAN','MANSILLA QUEL','Cuarto ','MB4AV','PE4CV','JV','Mecánica Automotriz','0005569478');
call sp_agregarPersona2(39878,'2025283','José Manfrendy','Monterroso de León','Cuarto ','MB4AV','PE4AV','JV','Mecánica Automotriz','0007259173');
call sp_agregarPersona2(39879,'2025194','Carlos Rodrigo','Orozco Vivar','Cuarto ','MB4AV','PE4AV','JV','Mecánica Automotriz','0007332525');
call sp_agregarPersona2(39880,'2025138','Pablo Javier','Osorio Guzmán','Cuarto ','MB4AV','PE4AV','JV','Mecánica Automotriz','0007320914');
call sp_agregarPersona2(39881,'2025151','Diego Alfonso','Paz Tuquer','Cuarto ','MB4AV','PE4CV','JV','Mecánica Automotriz','0007310546');
call sp_agregarPersona2(39882,'2025343','Cesar Augusto','Perez Felipe','Cuarto ','MB4AM','PE4CM','JM','Mecánica Automotriz','0007300195');
call sp_agregarPersona2(39883,'2025218','Brayan Estuardo','Pérez Salmeron','Cuarto ','MB4AV','PE4CV','JV','Mecánica Automotriz','0007277070');
call sp_agregarPersona2(39884,'2025277','Jhostin Eliel','Pocon chamale','Cuarto ','MB4AV','PE4CV','JV','Mecánica Automotriz','0002733934');
call sp_agregarPersona2(39885,'2025368','LUIS EMANUEL','RUIZ CIPRIANO','Cuarto ','MB4AV','PE4AV','JV','Mecánica Automotriz','0002733864');
call sp_agregarPersona2(39886,'2025282','BRANDON ALEXANDER','SALES MAYEN','Cuarto ','MB4AV','PE4AV','JV','Mecánica Automotriz','0007255496');
call sp_agregarPersona2(39887,'2025300','David Emanuel','Sequén Alfaro','Cuarto ','MB4AV','PE4AV','JV','Mecánica Automotriz','0002742995');
call sp_agregarPersona2(39888,'2025153','Luis Adrian','Solares Vega','Cuarto ','MB4AV','PE4CV','JV','Mecánica Automotriz','0002742916');
call sp_agregarPersona2(39889,'2025338','SERGIO SAMUEL DAVID','SOLORZANO BARBERO','Cuarto ','MB4AV','PE4AV','JV','Mecánica Automotriz','0007254459');
call sp_agregarPersona2(39890,'2025167','Juan Amílcar','Vargas Tzaquitzal','Cuarto ','MB4AV','PE4CV','JV','Mecánica Automotriz','0002742926');
call sp_agregarPersona2(39891,'2022098','Adolfo de Jesús','Salvador Arce','Cuarto ','MB4BV','PE4BV','JV','Mecánica Automotriz','0002742945');
call sp_agregarPersona2(39892,'2025419','Abner Abimael','Ajú Ramos','Cuarto ','MB4BV','PE4DV','JV','Electrónica básica','0007245123');
call sp_agregarPersona2(39893,'2025295','Jeferson Alexander','Aldana Ixcayau','Cuarto ','MB4BV','PE4BV','JV','Mecánica Automotriz','0008002246');
call sp_agregarPersona2(39894,'2025341','Jesus Eugenio','Alvarado Herrera','Cuarto ','MB4BV','PE4BV','JV','Mecánica Automotriz','0008017522');
call sp_agregarPersona2(39895,'2025124','JUAN ANGEL ALBERTO','ALVIZURES PALMA','Cuarto ','MB4BV','PE4EV','JV','Mecánica Automotriz','0008035259');
call sp_agregarPersona2(39896,'2025201','Christopher Estuardo','Barillas Cabrera','Cuarto ','MB4BM','PE4DM','JM','Mecánica Automotriz','0007258937');
call sp_agregarPersona2(39897,'2025244','Carlos Javier','Barrios Moguel','Cuarto ','MB4BV','PE4DV','JV','Mecánica Automotriz','0007989372');
call sp_agregarPersona2(39898,'2025259','Diego Miguel','Canel Marroquin','Cuarto ','MB4BV','PE4EV','JV','Mecánica Automotriz','0008050758');
call sp_agregarPersona2(39899,'2021568','Daniel Sebastian','Castro Orozco','Cuarto ','MB4BV','PE4BV','JV','Mecánica Automotriz','0008064779');
call sp_agregarPersona2(39900,'2025183','Héctor Alfredo','Castro Tamup','Cuarto ','MB4BV','PE4EV','JV','Mecánica Automotriz','0008056005');
call sp_agregarPersona2(39901,'2025200','Jeshua Isaac','Chacón Velasco','Cuarto ','MB4BV','PE4EV','JV','Mecánica Automotriz','0008061010');
call sp_agregarPersona2(39902,'2025208','Víctor Emanuel','Chaperón Alpires','Cuarto ','MB4BV','PE4EV','JV','Mecánica Automotriz','0008067208');
call sp_agregarPersona2(39903,'2025315','Cristian Centeno','Choc Ical','Cuarto ','MB4BV','PE4BV','JV','Mecánica Automotriz','0008053691');
call sp_agregarPersona2(39904,'2025305','Josué David','Corzo España','Cuarto ','MB4BV','PE4BV','JV','Mecánica Automotriz','0008029351');
call sp_agregarPersona2(39905,'2025378','Cristian Alexander','De la Cruz Reyes','Cuarto ','MB4BV','PE4DV','JV','Mecánica Automotriz','0008020144');
call sp_agregarPersona2(39906,'2022395','Roberto Elías','Escobar de León','Cuarto ','MB4BV','PE4EV','JV','Mecánica Automotriz','0008040233');
call sp_agregarPersona2(39907,'2025150','José Adrián','Flores Enriquez','Cuarto ','MB4BV','PE4DV','JV','Mecánica Automotriz','0008053623');
call sp_agregarPersona2(39908,'2025229','Cristofer David','Fuentes Perez','Cuarto ','MB4BV','PE4EV','JV','Mecánica Automotriz','0008062897');
call sp_agregarPersona2(39909,'2025285','Wilmer Ulysses','Gómez Pérez','Cuarto ','MB4BV','PE4BV','JV','Mecánica Automotriz','0008075993');
call sp_agregarPersona2(39910,'2025181','Igmar Santiago','Hernández Rodríguez','Cuarto ','MB4BV','PE4BV','JV','Mecánica Automotriz','0007281686');
call sp_agregarPersona2(39911,'2025270','Anderson Gabriel Enrique','Lara Monzon','Cuarto ','MB4BV','PE4DV','JV','Mecánica Automotriz','0007988348');
call sp_agregarPersona2(39912,'2025139','Josué Alejandro','López Fuentes','Cuarto ','MB4BV','PE4EV','JV','Mecánica Automotriz','0008027940');
call sp_agregarPersona2(39913,'2025377','HESSLER JAASIEL','MAZARIEGOS MENDEZ','Cuarto ','MB4BV','PE4DV','JV','Mecánica Automotriz','0008048042');
call sp_agregarPersona2(39914,'2025288','José Emiliano','Mazariegos Roldán','Cuarto ','MB4BV','PE4BV','JV','Mecánica Automotriz','0008060815');
call sp_agregarPersona2(39915,'2025205','Jose Leonel','Morales Gonzalez','Cuarto ','MB4BV','PE4EV','JV','Mecánica Automotriz','0008035758');
call sp_agregarPersona2(39916,'2025350','Jonathan Rodolfo','Morales Ramírez','Cuarto ','MB4BV','PE4DV','JV','Mecánica Automotriz','0008020635');
call sp_agregarPersona2(39917,'2025140','Yeshua David André','Ortiz Fino','Cuarto ','MB4BV','PE4BV','JV','Mecánica Automotriz','0008002393');
call sp_agregarPersona2(39918,'2025309','Axel Javier','Pèrez Lòpez','Cuarto ','MB4BV','PE4DV','JV','Mecánica Automotriz','0008052306');
call sp_agregarPersona2(39919,'2025207','Cristian Francisco','Tavico Yoc','Cuarto ','MB4BV','PE4EV','JV','Mecánica Automotriz','0008038846');
call sp_agregarPersona2(39920,'2025298','Joel Isaias','Toc Castañon','Cuarto ','MB4BV','PE4DV','JV','Mecánica Automotriz','0007272505');
call sp_agregarPersona2(39921,'2025547','Josué Benjamín','Álvarez Caal','Cuarto ','IN4AV','PE4CV','JV','Computación','0008051877');
call sp_agregarPersona2(39922,'2025501','Dominick Sebastián','Chavarria marroquin','Cuarto ','IN4AV','PE4AV','JV','Computación','0007288708');
call sp_agregarPersona2(39923,'2025144','ERICK SEBASTIAN','CHIQUITO AGUILAR','Cuarto ','IN4AV','PE4AV','JV','Computación','0007309529');
call sp_agregarPersona2(39924,'2022260','Djoser Emanuel','Figueroa Jiménez','Cuarto ','IN4AV','PE4AV','JV','Computación','0007275489');
call sp_agregarPersona2(39925,'2022373','Jeshua Israel','Flores Zapeta','Cuarto ','IN4AV','PE4CV','JV','Computación','0007283791');
call sp_agregarPersona2(39926,'2025292','Pablo Ignacio','Garcia Giron','Cuarto ','IN4AV','PE4CV','JV','Computación','0007312483');
call sp_agregarPersona2(39927,'2025177','Isaí Antonio','Gómez Morales','Cuarto ','IN4AV','PE4CV','JV','Computación','0007307282');
call sp_agregarPersona2(39928,'2025549','JULIAN ELIGIO','JAX CISNEROS','Cuarto ','IN4AV','PE4AV','JV','Educación Básica','0005569475');
call sp_agregarPersona2(39929,'2025598','Fares Alejandro','López Castañon','Cuarto ','IN4AV','PE4AV','JV','Computación','0005569480');
call sp_agregarPersona2(39930,'2025358','JUSTIN FERNANDO','LÓPEZ MORALES','Cuarto ','IN4AV','PE4AV','JV','Computación','0005566373');
call sp_agregarPersona2(39931,'2025116','Carlos Eduardo','Morán Córdova','Cuarto ','IN4AV','PE4CV','JV','Computación','0005566378');
call sp_agregarPersona2(39932,'2025337','Andesrson David','Mucía Ixén','Cuarto ','IN4AV','PE4AV','JV','Computación','0007328134');
call sp_agregarPersona2(39933,'2025361','Marcos Dionel','Nicolás López','Cuarto ','IN4AV','PE4CV','JV','Computación','0007313066');
call sp_agregarPersona2(39934,'2025291','Yubini Emanuel','Perez Oajaca','Cuarto ','IN4AV','PE4AV','JV','Computación','0007298608');
call sp_agregarPersona2(39935,'2025335','Kevin Omar','Reyes Bautista','Cuarto ','IN4AV','PE4CV','JV','Computación','0007252063');
call sp_agregarPersona2(39936,'2025041','Angel Edmundo','Ruiz diaz','Cuarto ','IN4AV','PE4AV','JV','Computación','0007327184');
call sp_agregarPersona2(39937,'2025319','Mynor Eduardo Enrique','Sánchez Tzaj','Cuarto ','IN4AV','PE4CV','JV','Computación','0007290469');
call sp_agregarPersona2(39938,'2025365','Justin Alexander','Sandoval Colpetán','Cuarto ','IN4AV','PE4AV','JV','Computación','0007304784');
call sp_agregarPersona2(39939,'2025347','Pablo Esteban','Sipac Fuentes','Cuarto ','IN4AV','PE4CV','JV','Computación','0007310690');
call sp_agregarPersona2(39940,'2025576','Luis armando','Soc tun','Cuarto ','IN4AV','PE4AV','JV','Computación','0007314786');
call sp_agregarPersona2(39941,'2025349','JONATHAN ROCAEL','TIÑO PEREZ','Cuarto ','IN4AV','PE4AV','JV','Computación','0007306728');
call sp_agregarPersona2(39942,'2023335','Jorge Rodrigo','Torres Montenegro','Cuarto ','IN4AV','PE4AV','JV','Computación','0007309512');
call sp_agregarPersona2(39943,'2025318','Denis Ottoniel','Tuquer Vasquez','Cuarto ','IN4AV','PE4AV','JV','Computación','0007309806');
call sp_agregarPersona2(39944,'2025353','Wilson Ronaldo','Tut Caal','Cuarto ','IN4AV','PE4CV','JV','Computación','0007247818');
call sp_agregarPersona2(39945,'2025287','Carlos Javier','Xocop Batz','Cuarto ','IN4AV','PE4CV','JV','Computación','0007242486');
call sp_agregarPersona2(39946,'2025457','Angel David','Alfaro Ochoa','Cuarto ','IN4CV','PE4EV','JV','Computación','0008076500');
call sp_agregarPersona2(39947,'2025436','Michael Yohardi','Aquino Argueta','Cuarto ','IN4CV','PE4BV','JV','Computación','0007260414');
call sp_agregarPersona2(39948,'2025577','Derek Jaadiel','Arreaga Canté','Cuarto ','IN4CV','PE4EV','JV','Computación','0007275199');
call sp_agregarPersona2(39949,'2025512','Jhulian Roberth Gaddiel','Batres Barrera','Cuarto ','IN4CV','PE4EV','JV','Computación','0007306034');
call sp_agregarPersona2(39950,'2022102','Randolf Alfredo','Bran Reyes','Cuarto ','IN4CV','PE4EV','JV','Computación','0007290525');
call sp_agregarPersona2(39951,'2022406','Edy Enrique','Canel Castillo','Cuarto ','IN4CV','PE4BV','JV','Computación','0007250820');
call sp_agregarPersona2(39952,'2025548','Mario Alberto','Cifuentes de León','Cuarto ','IN4CV','PE4BV','JV','Computación','0007302760');
call sp_agregarPersona2(39953,'2025241','Brayan Andres','Coronado Fuentes','Cuarto ','IN4CV','PE4EV','JV','Computación','0007315710');
call sp_agregarPersona2(39954,'2025269','Pablo José','Cos Taracena','Cuarto ','IN4CV','PE4EV','JV','Computación','0007292029');
call sp_agregarPersona2(39955,'2021322','Diego Sebastián','De León Barrios','Cuarto ','IN4CV','PE4EV','JV','Computación','0007299934');
call sp_agregarPersona2(39956,'2022360','Oliver Andre','Garcia Sicaja','Cuarto ','IN4CV','PE4BV','JV','Computación','0007315852');
call sp_agregarPersona2(39957,'2025464','Andres Angel emmanuel','Gonzalez Garcia','Cuarto ','IN4CV','PE4DV','JV','Computación','0007329025');
call sp_agregarPersona2(39958,'2025428','JEREMY JOEL','ORDOÑEZ JUAREZ','Cuarto ','IN4CV','PE4DV','JV','Computación','0007285294');
call sp_agregarPersona2(39959,'2025445','Josué Daniel','Ortega Súchite','Cuarto ','IN4CV','PE4DV','JV','Computación','0007304852');
call sp_agregarPersona2(39960,'2025454','Edgar David Alexander','Osorio Sis','Cuarto ','IN4CV','PE4EV','JV','Computación','0007333734');
call sp_agregarPersona2(39961,'2025262','Pablo David','Requena Mollinedo','Cuarto ','IN4CV','PE4DV','JV','Computación','0008017928');
call sp_agregarPersona2(39962,'2025272','ARIEL BENJAMIN','RUANO MOYA','Cuarto ','IN4CV','PE4BV','JV','Computación','0007311740');
call sp_agregarPersona2(39963,'2025463','MARLON OBED','SUYUC BAJAN','Cuarto ','IN4CV','PE4BV','JV','Computación','0005490275');
call sp_agregarPersona2(39964,'2025478','José Lionzo','Xic Chay','Cuarto ','IN4CV','PE4BV','JV','Computación','0005490278');
call sp_agregarPersona2(39965,'2025202','Christian Fernando','Alemán Velásquez','Cuarto ','EL4AV','PE4BV','JV','Electricidad Industrial','0008046501');
call sp_agregarPersona2(39966,'2025342','Derick Giovanni','Arévalo Lemus','Cuarto ','EL4AV','PE4BV','JV','Electricidad Industrial','0007303754');
call sp_agregarPersona2(39967,'2025387','Jonathan René','Chanchavac Pelicó','Cuarto ','EL4AV','PE4BV','JV','Electricidad Industrial','0007248939');
call sp_agregarPersona2(39968,'2025459','Jhostin Alexander','Choc Páz','Cuarto ','EL4AV','PE4BV','JV','Electricidad Industrial','0007264399');
call sp_agregarPersona2(39969,'2025452','Ronald Alexander','Cifuentes González','Cuarto ','EL4AV','PE4DV','JV','Electricidad Industrial','0007243905');
call sp_agregarPersona2(39970,'2025528','Pablo Andres','Galeano Pineda','Cuarto ','EL4AV','PE4DV','JV','Electricidad Industrial','0004806233');
call sp_agregarPersona2(39971,'2025448','Lester Misael','Jucup Yol','Cuarto ','EL4AV','PE4BV','JV','Electricidad Industrial','0004806228');
call sp_agregarPersona2(39972,'2025462','André José David','López Chamo','Cuarto ','EL4AV','PE4DV','JV','Electricidad Industrial','0007276391');
call sp_agregarPersona2(39973,'2025513','Brayan Javier','Mejia rodas','Cuarto ','EL4AV','PE4DV','JV','Electricidad Industrial','0007267397');
call sp_agregarPersona2(39974,'2025400','Alex Rodrigo','Ovando Mayorga','Cuarto ','EL4AV','PE4BV','JV','Electricidad Industrial','0007259849');
call sp_agregarPersona2(39975,'2025278','Anderson Rodolfo','Oxcal Vicente','Cuarto ','EL4AV','PE4DV','JV','Electricidad Industrial','0007308690');
call sp_agregarPersona2(39976,'2025568','Jefferson David','Pérez Patzan','Cuarto ','EL4AV','PE4DV','JV','Electricidad Industrial','0007299520');
call sp_agregarPersona2(39977,'2025416','José Roberto','Reyes Ordoñez','Cuarto ','EL4AV','PE4BV','JV','Electricidad Industrial','0008026309');
call sp_agregarPersona2(39978,'2025437','Henry Alejandro','Samayoa Arevalo','Cuarto ','EL4AV','PE4BV','JV','Electrónica básica','0008076612');
call sp_agregarPersona2(39979,'2025572','Ángel André','Sazo Urìas','Cuarto ','EL4AV','PE4DV','JV','Electricidad Industrial','0008017779');
call sp_agregarPersona2(39980,'2025306','Jorge Ernesto','Alvarez Perez','Cuarto ','IN4BV','PE4DV','JV','Computación','0007251913');
call sp_agregarPersona2(39981,'2025376','Jose Rodrigo','Aquino Gonzalez','Cuarto ','IN4BV','PE4BV','JV','Computación','0002760717');
call sp_agregarPersona2(39982,'2022425','Juan Pablo','Cajchun Polanco','Cuarto ','IN4BV','PE4EV','JV','Computación','0002760712');
call sp_agregarPersona2(39983,'2025434','Brayan Oswaldo','Campa Fuentes','Cuarto ','IN4BV','PE4EV','JV','Computación','0002760707');
call sp_agregarPersona2(39984,'2025228','Angel Benjamin','Cardona Monzón','Cuarto ','IN4BV','PE4DV','JV','Computación','0002760722');
call sp_agregarPersona2(39985,'2025216','Angel Daniel','Chacón Gómez','Cuarto ','IN4BV','PE4BV','JV','Computación','0002735799');
call sp_agregarPersona2(39986,'2025439','Hansel Rodrigo','Escobar Pichillá','Cuarto ','IN4BV','PE4BV','JV','Computación','0002735794');
call sp_agregarPersona2(39987,'2025537','Elías Reynaldo','Esté García','Cuarto ','IN4BV','PE4BV','JV','Computación','0002735789');
call sp_agregarPersona2(39988,'2025508','José Andrés','García Hernández','Cuarto ','IN4BV','PE4EV','JV','Computación','0002716987');
call sp_agregarPersona2(39989,'2025379','Anderson Ricardo Jafet','Gómez García','Cuarto ','IN4BV','PE4BV','JV','Computación','0002724980');
call sp_agregarPersona2(39990,'2025422','Oscar José luis','Guzmán Pineda','Cuarto ','IN4BV','PE4BV','JV','Computación','0002734080');
call sp_agregarPersona2(39991,'2025582','Esteban Rodrigo','Hernández Hernández','Cuarto ','IN4BV','PE4BV','JV','Computación','0002734075');
call sp_agregarPersona2(39992,'2025316','Jefferson Geovanny','Juárez Ruano','Cuarto ','IN4BV','PE4DV','JV','Computación','0002694609');
call sp_agregarPersona2(39993,'2025414','Jaime Gerardo','Martínez Gómez','Cuarto ','IN4BV','PE4EV','JV','Computación','0002694614');
call sp_agregarPersona2(39994,'2025363','Xavi Fernando','Paiz Ruiz','Cuarto ','IN4BV','PE4DV','JV','Electrónica Industrial','0002694619');
call sp_agregarPersona2(39995,'2025219','Rudy Stuardo','Piloña Monzón','Cuarto ','IN4BV','PE4BV','JV','Computación','0007273143');
call sp_agregarPersona2(39996,'2025491','Alvaro David','Real Pirir','Cuarto ','IN4BV','PE4DV','JV','Computación','0007323740');
call sp_agregarPersona2(39997,'2025195','David Alejandro','Toc Orozco','Cuarto ','IN4BV','PE4DV','JV','Computación','0007245538');
call sp_agregarPersona2(39998,'2025193','Diego Ramón','Velásquez Girón','Cuarto ','IN4BV','PE4BV','JV','Computación','0007292145');
call sp_agregarPersona2(39999,'2024014','José Alonzo','Aifán Cruz','Quinto ','DB5AM','PE5CM','JM','Dibujo Técnico','0007269821');
call sp_agregarPersona2(40000,'2024112','Sebastian','Arenales Lara','Quinto ','DB5AM','PE5CM','JM','Dibujo Técnico','0007288131');
call sp_agregarPersona2(40001,'2021652','Bryan Alejandro','Ben Paxtor','Quinto ','DB5AM','PE5CM','JM','Dibujo Técnico','0007272205');
call sp_agregarPersona2(40002,'2024046','Elias Fernándo','Chajón Iquic','Quinto ','DB5AM','PE5CM','JM','Dibujo Técnico','0007278779');
call sp_agregarPersona2(40003,'2021385','Dylan Gabriel Eduardo','Chinchilla García','Quinto ','DB5AM','PE5CM','JM','Dibujo Técnico','0007265688');
call sp_agregarPersona2(40004,'2021192','Gerardo Daniel','Chitay Castro','Quinto ','DB5AM','PE5CM','JM','Dibujo Técnico','0007281265');
call sp_agregarPersona2(40005,'2024514','Edgar Manuel','Cruz Chajón','Quinto ','DB5AM','PE5CM','JM','Dibujo Técnico','0007269462');
call sp_agregarPersona2(40006,'2021454','Pablo Antonio','de León García','Quinto ','DB5AM','PE5CM','JM','Dibujo Técnico','0007295969');
call sp_agregarPersona2(40007,'2021218','Jose Eduardo','del Valle Robles','Quinto ','DB5AM','PE5CM','JM','Dibujo Técnico','0007333133');
call sp_agregarPersona2(40008,'2024212','Allan Wladimir','Ercin Garcia','Quinto ','DB5AM','PE5BM','JM','Dibujo Técnico','0007323210');
call sp_agregarPersona2(40009,'2024426','Anthony Johaf','Grijalba Guerra','Quinto ','DB5AM','PE5CM','JM','Dibujo Técnico','0007310008');
call sp_agregarPersona2(40010,'2021232','RICHARD EIDAN','GUZMAN FLORES','Quinto ','DB5AM','PE5CM','JM','Dibujo Técnico','0007327219');
call sp_agregarPersona2(40011,'2021524','Iverson David','Hernandez Pelaez','Quinto ','DB5AM','PE5BM','JM','Dibujo Técnico','0007253546');
call sp_agregarPersona2(40012,'2024077','Adrián Alejandro','Higueros Marroquin','Quinto ','DB5AM','PE5CM','JM','Dibujo Técnico','0007274188');
call sp_agregarPersona2(40013,'2021359','Hector Enrique','Jimenez Galvez','Quinto ','DB5AM','PE5CM','JM','Dibujo Técnico','0007265836');
call sp_agregarPersona2(40014,'2024111','Luis Jacobo','Lemus Guillén','Quinto ','DB5AM','PE5CM','JM','Dibujo Técnico','0007314422');
call sp_agregarPersona2(40015,'2024115','David Carloandre','Marroquín Ramirez','Quinto ','DB5AM','PE5CM','JM','Dibujo Técnico','0007300423');
call sp_agregarPersona2(40016,'2024038','Hinmer Manuel','Martín Alvarado','Quinto ','DB5AM','PE5CM','JM','Dibujo Técnico','0007244725');
call sp_agregarPersona2(40017,'2021147','Anderson Samuel','Meneses Albisurez','Quinto ','DB5AM','PE5CM','JM','Dibujo Técnico','0007254139');
call sp_agregarPersona2(40018,'2024049','Marlon Samuel','Molina Batz','Quinto ','DB5AM','PE5CM','JM','Dibujo Técnico','0007306584');
call sp_agregarPersona2(40019,'2024034','MIGUEL ALEJANDRO','MONTEJO HERNÁNDEZ','Quinto ','DB5AM','PE5CM','JM','Dibujo Técnico','0007316512');
call sp_agregarPersona2(40020,'2024234','Melvin Josué David','Morales Gabriel','Quinto ','DB5AM','PE5CM','JM','Dibujo Técnico','0007319991');
call sp_agregarPersona2(40021,'2024098','Diego Abraham','Orozco López','Quinto ','DB5AM','PE5CM','JM','Dibujo Técnico','0007320251');
call sp_agregarPersona2(40022,'2024197','Guillermo Sebastian','Palacios Mazariegos','Quinto ','DB5AM','PE5BM','JM','Dibujo Técnico','0007311288');
call sp_agregarPersona2(40023,'2021500','Eliseo Benjamin','Patzan Tzic','Quinto ','DB5AM','PE5BM','JM','Computación','0007265507');
call sp_agregarPersona2(40024,'2024171','Jean Carlos','Pirir Morales','Quinto ','DB5AM','PE5BM','JM','Dibujo Técnico','0007253470');
call sp_agregarPersona2(40025,'2021136','Denis Orlando','Ruano González','Quinto ','DB5AM','PE5BM','JM','Dibujo Técnico','0007243380');
call sp_agregarPersona2(40026,'2021363','Diego Alejandro','Tánchez Cáceres','Quinto ','DB5AM','PE5BM','JM','Dibujo Técnico','0007258111');
call sp_agregarPersona2(40027,'2020334','Leonardo Abraham','Tol Yucuté','Quinto ','DB5AM','PE5BM','JM','Dibujo Técnico','0007284277');
call sp_agregarPersona2(40028,'2024063','Sergio Orlando','Torres Aspuac','Quinto ','DB5AM','PE5BM','JM','Dibujo Técnico','0007293804');
call sp_agregarPersona2(40029,'2024023','Miguel Ángel de Jesús','Vicente tiquiran','Quinto ','DB5AM','PE5BM','JM','Dibujo Técnico','0007317655');
call sp_agregarPersona2(40030,'2021388','José María','Virula Guzmán','Quinto ','DB5AM','PE5BM','JM','Dibujo Técnico','0002746504');
call sp_agregarPersona2(40031,'2021509','Gabriel André','Avila Nuñez','Quinto ','EB5BM','PE5DM','JM','Electrónica Computación','0007322761');
call sp_agregarPersona2(40032,'2024074','Fernando Xavier','Bai Muñoz','Quinto ','EB5BM','PE5DM','JM','Electrónica Industrial','0007329770');
call sp_agregarPersona2(40033,'2021707','EDER EULALIO','CARDONA AGUILON','Quinto ','EB5BM','PE5DM','JM','Electrónica básica','0007260789');
call sp_agregarPersona2(40034,'2024061','Pablo José','Colindres Ortega','Quinto ','EB5BM','PE5DM','JM','Electrónica básica','0007312408');
call sp_agregarPersona2(40035,'2024224','Edgar Estuardo','de leon leon','Quinto ','EB5BM','PE5DM','JM','Electrónica básica','0007314383');
call sp_agregarPersona2(40036,'2024192','Emanuel David','de León Mazariegos','Quinto ','EB5BM','PE5DM','JM','Electrónica básica','0007318913');
call sp_agregarPersona2(40037,'2021530','Cristian Gabriel','Dubón Ubedo','Quinto ','EB5BM','PE5DM','JM','Electrónica básica','0007315940');
call sp_agregarPersona2(40038,'2024230','José Rodrigo','Godinez Almengor','Quinto ','EB5BM','PE5DM','JM','Electrónica básica','0007279549');
call sp_agregarPersona2(40039,'2023444','Byron Efraín','López Teleguario','Quinto ','EB5BM','PE5DM','JM','Electrónica básica','0007319050');
call sp_agregarPersona2(40040,'2024095','Miguel Andrés','Mejía Tórtola','Quinto ','EB5BM','PE5DM','JM','Electrónica básica','0007301730');
call sp_agregarPersona2(40041,'2021642','Hamdy Alejandro','Molina Jolomocox','Quinto ','EB5BM','PE5DM','JM','Electrónica básica','0007286666');
call sp_agregarPersona2(40042,'2021268','Josue Gabriel','Montenegro Castillo','Quinto ','EB5BM','PE5DM','JM','Electrónica básica','0007321832');
call sp_agregarPersona2(40043,'2024128','Anderson Manuel','Osoy Mendoza','Quinto ','EB5BM','PE5DM','JM','Electrónica básica','0007273220');
call sp_agregarPersona2(40044,'2024188','Oswal Alfonso','Rodriguez Boror','Quinto ','EB5BM','PE5AM','JM','Electrónica básica','0007245615');
call sp_agregarPersona2(40045,'2023341','Julio Sebastian','Rodriguez Gonzalez','Quinto ','EB5BM','PE5DM','JM','Electrónica básica','0008040721');
call sp_agregarPersona2(40046,'2021482','Daniel Andres','Sandoval Menéndez','Quinto ','EB5BM','PE5DM','JM','Electrónica básica','0008016498');
call sp_agregarPersona2(40047,'2024094','Jose Eduardo Fermin','Sincal Coy','Quinto ','EB5BM','PE5DM','JM','Electrónica básica','0004740727');
call sp_agregarPersona2(40048,'2021162','Marcos Samuel Alessandro de Jesús','Sosa Joj','Quinto ','EB5BM','PE5DM','JM','Electrónica básica','0007301579');
call sp_agregarPersona2(40049,'2021649','Cristopher Andrade','Tahuico Hernández','Quinto ','EB5BM','PE5DM','JM','Electrónica básica','0007263953');
call sp_agregarPersona2(40050,'2021635','Bruno Jose','Tajiboy Shon','Quinto ','EB5BM','PE5AM','JM','Electrónica básica','0007275147');
call sp_agregarPersona2(40051,'2021637','Rodrigo Alejandro','Tepaz Vela','Quinto ','EB5BM','PE5AM','JM','Electrónica básica','0007293828');
call sp_agregarPersona2(40052,'2021151','Crystian Yovany','Alvarado Castillo','Quinto ','EB5AM','PE5BM','JM','Electrónica básica','0002767291');
call sp_agregarPersona2(40053,'2021135','Sebastian Antonio','Arriaza Castillo','Quinto ','EB5AM','PE5BM','JM','Electrónica básica','0007317002');
call sp_agregarPersona2(40054,'2021475','Samuel Esteban','Cáceres Anguiano','Quinto ','EB5AM','PE5BM','JM','Electrónica básica','0007265539');
call sp_agregarPersona2(40055,'2024019','Angel Francisco','Chutá Mejía','Quinto ','EB5AM','PE5BM','JM','Electrónica básica','0007285979');
call sp_agregarPersona2(40056,'2021367','José André','Coronado Juárez','Quinto ','EB5AM','PE5BM','JM','Electrónica básica','0007287234');
call sp_agregarPersona2(40057,'2021306','Leandro Andree','Diaz Zapeta','Quinto ','EB5AM','PE5BM','JM','Electrónica básica','0007304554');
call sp_agregarPersona2(40058,'2021145','Fabian Enrique','García Morales','Quinto ','EB5AM','PE5BM','JM','Electrónica básica','0007302185');
call sp_agregarPersona2(40059,'2024031','Brandon Antonio','García Morales','Quinto ','EB5AM','PE5BM','JM','Electrónica básica','0007323355');
call sp_agregarPersona2(40060,'2024011','Gustavo Andres','Godoy Mutz','Quinto ','EB5AM','PE5BM','JM','Electrónica básica','0007284722');
call sp_agregarPersona2(40061,'2021630','Julio Eduardo','Hernández Ochoa','Quinto ','EB5AM','PE5BM','JM','Electrónica básica','0007319881');
call sp_agregarPersona2(40062,'2024002','Marvin Iván','Ixén Cojti','Quinto ','EB5AM','PE5BM','JM','Electrónica básica','0007256957');
call sp_agregarPersona2(40063,'2021558','Christopher Alexander','López Holzberg','Quinto ','EB5AM','PE5BM','JM','Electrónica básica','0007242400');
call sp_agregarPersona2(40064,'2024153','Sergio Esteban','Monzón Velásquez','Quinto ','EB5AM','PE5BM','JM','Electrónica básica','0007330403');
call sp_agregarPersona2(40065,'2021166','Diego Jared','Muñoz Monroy','Quinto ','EB5AM','PE5BM','JM','Electrónica Computación','0007321670');
call sp_agregarPersona2(40066,'2021153','Oswaldo Benjamín','Noj Xocoxic','Quinto ','EB5AM','PE5BM','JM','Electrónica básica','0007320384');
call sp_agregarPersona2(40067,'2024012','Jose Marco','Ramirez Escobar','Quinto ','EB5AM','PE5BM','JM','Electrónica básica','0007243647');
call sp_agregarPersona2(40068,'2024144','Sergio Giovanni','Rodriguez Soto','Quinto ','EB5AM','PE5BM','JM','Electrónica básica','0007254457');
call sp_agregarPersona2(40069,'2021503','Carlos Andre','Romero Garcia','Quinto ','EB5AM','PE5BM','JM','Electrónica básica','0007269621');
call sp_agregarPersona2(40070,'2024140','Cristian Daniel','Saravia de la Cruz','Quinto ','EB5AM','PE5BM','JM','Electrónica básica','0007302977');
call sp_agregarPersona2(40071,'2021002','Luis Andres','Veliz Barillas','Quinto ','EB5AM','PE5BM','JM','Electrónica básica','0007305621');
call sp_agregarPersona2(40072,'2024045','Carlos Fabrissio.','Vielman Muñoz.','Quinto ','EB5AM','PE5BM','JM','Electrónica básica','0007324911');
call sp_agregarPersona2(40073,'2021235','Emilio Sebastián','Barrera cali','Quinto ','IN5AM','PE5DM','JM','Computación','0004800822');
call sp_agregarPersona2(40074,'2024525','José Emilio','Bolaños López','Quinto ','IN5AM','PE5DM','JM','Computación','0007295990');
call sp_agregarPersona2(40075,'2021276','Luis Fernando','Castro Xicon','Quinto ','IN5AM','PE5DM','JM','Computación','0007272428');
call sp_agregarPersona2(40076,'2024133','EDGAR ROBERTO GENARO','CATALÀN MÈNDEZ','Quinto ','IN5AM','PE5AM','JM','Computación','0007257951');
call sp_agregarPersona2(40077,'2021174','José Carlos','Cortez López','Quinto ','IN5AM','PE5DM','JM','Computación','0007261214');
call sp_agregarPersona2(40078,'2021222','Alejandro Arturo','Echeverría Garrido','Quinto ','IN5AM','PE5AM','JM','Computación','0004806634');
call sp_agregarPersona2(40079,'2021308','Diego Benjamin','Espinoza Reyes','Quinto ','IN5AM','PE5DM','JM','Computación','0007314762');
call sp_agregarPersona2(40080,'2024041','Wagner Alexander','Espinoza Salay','Quinto ','IN5AM','PE5DM','JM','Computación','0007301718');
call sp_agregarPersona2(40081,'2024043','Angelo Ricardo','García Hernández','Quinto ','IN5AM','PE5DM','JM','Computación','0007298652');
call sp_agregarPersona2(40082,'2021272','Estuardo Daniel','Gómez Chity','Quinto ','IN5AM','PE5DM','JM','Computación','0007328178');
call sp_agregarPersona2(40083,'2024075','Jose Juliàn','Gonzales Robles','Quinto ','IN5AM','PE5DM','JM','Educación Básica','0005687035');
call sp_agregarPersona2(40084,'2024374','Jose Rodrigo','González Vásquez','Quinto ','IN5AM','PE5AM','JM','Computación','0007280383');
call sp_agregarPersona2(40085,'2024054','José Waldemar','Gutierrez García','Quinto ','IN5AM','PE5DM','JM','Computación','0007275550');
call sp_agregarPersona2(40086,'2021238','Lucian Guillermo','Juarez Ispanel','Quinto ','IN5AM','PE5AM','JM','Computación','0007296445');
call sp_agregarPersona2(40087,'2021393','ESDRAS EDILIO','LÓPEZ AJANEL','Quinto ','IN5AM','PE5DM','JM','Computación','0007293646');
call sp_agregarPersona2(40088,'2024108','Daniel Alejandro','Marroquin Zabala','Quinto ','IN5AM','PE5DM','JM','Computación','0007258051');
call sp_agregarPersona2(40089,'2021116','Sebastian Wilder Eduardo','Méndez Barillas','Quinto ','IN5AM','PE5DM','JM','Computación','0007285632');
call sp_agregarPersona2(40090,'2024055','Jose Gerardo','Méndez Gonzalez','Quinto ','IN5AM','PE5DM','JM','Computación','0007252835');
call sp_agregarPersona2(40091,'2024073','Edwin Fernando','Muxtay Fuentes','Quinto ','IN5AM','PE5AM','JM','Computación','0007326357');
call sp_agregarPersona2(40092,'2021373','Jose Carlos','Rodas Macal','Quinto ','IN5AM','PE5AM','JM','Computación','0007310002');
call sp_agregarPersona2(40093,'2024114','Carlos Alejandro','Sanchez Solares','Quinto ','IN5AM','PE5AM','JM','Computación','0007247673');
call sp_agregarPersona2(40094,'2024238','Joshua Vladimir','Solares Gonzalez','Quinto ','IN5AM','PE5AM','JM','Computación','0007248067');
call sp_agregarPersona2(40095,'2021469','Antony Andree','Tun García','Quinto ','IN5AM','PE5AM','JM','Computación','0007259235');
call sp_agregarPersona2(40096,'2021152','Christian Geovanni','Xicara Cifuentes','Quinto ','IN5AM','PE5AM','JM','Computación','0007284241');
call sp_agregarPersona2(40097,'2021176','Louis Brando','Xiloj Subuyú','Quinto ','IN5AM','PE5AM','JM','Computación','0007298735');
call sp_agregarPersona2(40098,'2024059','Mauricio Neftalí','Xocoxic Patzán','Quinto ','IN5AM','PE5AM','JM','Computación','0007293787');
call sp_agregarPersona2(40099,'2021001','Juan Carlos','Zeta Juárez','Quinto ','IN5AM','PE5DM','JM','Computación','0007285802');
call sp_agregarPersona2(40100,'2021496','Andy Ariel','Ajiatas Xiquin','Quinto ','IN5CM','PE5DM','JM','Computación','0007313027');
call sp_agregarPersona2(40101,'2021497','Breyner Alexander','Benitez Diaz','Quinto ','IN5CM','PE5DM','JM','Computación','0007250612');
call sp_agregarPersona2(40102,'2024227','Marcos Rodrigo','Beteta Nájera','Quinto ','IN5CM','PE5DM','JM','Computación','0007248518');
call sp_agregarPersona2(40103,'2024018','Adrian Esteban','Camposeco Gálvez','Quinto ','IN5CM','PE5DM','JM','Computación','0007273615');
call sp_agregarPersona2(40104,'2021304','Marcos Danilo Sebastian','Cho Aguilar','Quinto ','IN5CM','PE5DM','JM','Computación','0007278062');
call sp_agregarPersona2(40105,'2021286','Leandro Johann','Choxón Maldonado','Quinto ','IN5CM','PE5DM','JM','Computación','0007248309');
call sp_agregarPersona2(40106,'2024150','Oliver Gabriel','Contreras Castellanos','Quinto ','IN5CM','PE5DM','JM','Computación','0007271980');
call sp_agregarPersona2(40107,'2024016','Giancarlo Sebastian','Cordova Garcia','Quinto ','IN5CM','PE5DM','JM','Computación','0007303134');
call sp_agregarPersona2(40108,'2021326','Angel Aroldo','De la Cruz Chanchavac','Quinto ','IN5CM','PE5DM','JM','Computación','0007258069');
call sp_agregarPersona2(40109,'2023220','Santiago Enrique','De Rosa Vasquez','Quinto ','IN5CM','PE5DM','JM','Computación','0007284462');
call sp_agregarPersona2(40110,'2022471','Mario Alejandro','Escobar Silva','Quinto ','IN5CM','PE5DM','JM','Computación','0007290870');
call sp_agregarPersona2(40111,'2021655','JACK ARAMED','FALLAS GOMEZ','Quinto ','IN5CM','PE5DM','JM','Computación','0007313405');
call sp_agregarPersona2(40112,'2024026','Javier Alesandro','Gomez Ramos','Quinto ','IN5CM','PE5DM','JM','Computación','0007313689');
call sp_agregarPersona2(40113,'2022434','Carlos Alexander','Guitz Barillas','Quinto ','IN5CM','PE5EM','JM','Computación','0007334409');
call sp_agregarPersona2(40114,'2021382','Diego Andrés','Leiva Palma','Quinto ','IN5CM','PE5EM','JM','Computación','0007334338');
call sp_agregarPersona2(40115,'2023086','Jose Eduardo','Lopez Garcia','Quinto ','IN5CM','PE5EM','JM','Computación','0007298257');
call sp_agregarPersona2(40116,'2021700','Diego Emilio','López Gutiérrez','Quinto ','IN5CM','PE5EM','JM','Computación','0007266705');
call sp_agregarPersona2(40117,'2024021','Fernando Alexander','Maldonado Peñate','Quinto ','IN5CM','PE5EM','JM','Computación','0007319313');
call sp_agregarPersona2(40118,'2022464','Diego Alessandro','Mauricio Bonilla','Quinto ','IN5CM','PE5EM','JM','Computación','0007333197');
call sp_agregarPersona2(40119,'2021255','KENNETH ANDERSON','MAZARIEGOS CACERES','Quinto ','IN5CM','PE5EM','JM','Computación','0007323287');
call sp_agregarPersona2(40120,'2021641','Oliver Javier','Mérida Lopez','Quinto ','IN5CM','PE5EM','JM','Computación','0007299802');
call sp_agregarPersona2(40121,'2021493','Roberto Antonio','Milián Reyna','Quinto ','IN5CM','PE5EM','JM','Computación','0005496745');
call sp_agregarPersona2(40122,'2021261','Luciano Alberto','Montufar Villalta','Quinto ','IN5CM','PE5EM','JM','Computación','0005496740');
call sp_agregarPersona2(40123,'2022388','José Lisandro','Morán Mendoza','Quinto ','IN5CM','PE5EM','JM','Computación','0005496661');
call sp_agregarPersona2(40124,'2024370','Hugo Daniel','Muralles Rivera','Quinto ','IN5CM','PE5EM','JM','Computación','0005496656');
call sp_agregarPersona2(40125,'2023502','Bradley Josué','Oliva Rodas','Quinto ','IN5CM','PE5EM','JM','Computación','0005496651');
call sp_agregarPersona2(40126,'2021698','Angel Fernando','Rodriguez Orellana','Quinto ','IN5CM','PE5EM','JM','Computación','0005496125');
call sp_agregarPersona2(40127,'2022439','Kenneth Franklin','Solórzano Canás','Quinto ','IN5CM','PE5EM','JM','Computación','0005496132');
call sp_agregarPersona2(40128,'2024024','Miguel Antonio','Tamat Ajuchán','Quinto ','IN5CM','PE5EM','JM','Computación','0005519930');
call sp_agregarPersona2(40129,'2022473','Kevin Estuardo','Velásquez Rivera','Quinto ','IN5CM','PE5EM','JM','Computación','0005519923');
call sp_agregarPersona2(40130,'2024007','Alessandro Felipe','Zacarías Oxcal','Quinto ','IN5CM','PE5EM','JM','Computación','0005519920');
call sp_agregarPersona2(40131,'2024030','Fernando Josué','Alvarado Alonzo','Quinto ','MA5AM','PE5AM','JM','Mecánica Automotriz','0007275545');
call sp_agregarPersona2(40132,'2024048','Kevin Alexander','Ascuc Coroy','Quinto ','MA5AM','PE5AM','JM','Mecánica Automotriz','0007256973');
call sp_agregarPersona2(40133,'2021266','Hugo René','Camey Torres','Quinto ','MA5AM','PE5AM','JM','Mecánica Automotriz','0007307462');
call sp_agregarPersona2(40134,'2021112','JAVIER ENRIQUE','CASTILLO MENDEZ','Quinto ','MA5AM','PE5AM','JM','Mecánica Automotriz','0007319195');
call sp_agregarPersona2(40135,'2024052','Jose Daniel','Castro Ulin','Quinto ','MA5AM','PE5AM','JM','Mecánica Automotriz','0007324999');
call sp_agregarPersona2(40136,'2021565','Joseph Anthony','Ceballos del Cid','Quinto ','MA5AM','PE5AM','JM','Mecánica Automotriz','0007313379');
call sp_agregarPersona2(40137,'2021264','Josué Ricardo','Coj Gonzalez','Quinto ','MA5AM','PE5AM','JM','Mecánica Automotriz','0007332634');
call sp_agregarPersona2(40138,'2021277','Erik Alberto','Cuá','Quinto ','MA5AM','PE5AM','JM','Mecánica Automotriz','0007330204');
call sp_agregarPersona2(40139,'2021241','Vince Uriel','Enriquez Garcia','Quinto ','MA5AM','PE5AM','JM','Mecánica Automotriz','0007317434');
call sp_agregarPersona2(40140,'2021003','Manuel Esteban','Fuentes Monzón','Quinto ','MA5AM','PE5AM','JM','Mecánica Automotriz','0007313312');
call sp_agregarPersona2(40141,'2024180','Anthony Rodrigo','González González','Quinto ','MA5AM','PE5AM','JM','Mecánica Automotriz','0007265849');
call sp_agregarPersona2(40142,'2021177','Carlos Jose','Gutiérrez Reyes','Quinto ','MA5AM','PE5AM','JM','Mecánica Automotriz','0007287720');
call sp_agregarPersona2(40143,'2021233','Steve Terry','Guzmán Flores','Quinto ','MA5AM','PE5AM','JM','Mecánica Automotriz','0007287408');
call sp_agregarPersona2(40144,'2024127','ANGEL OSWALDO ROMEO','JUAREZ LOPEZ','Quinto ','MA5AM','PE5AM','JM','Mecánica Automotriz','0007307108');
call sp_agregarPersona2(40145,'2021020','Jonathan Fernando','López Arreaga','Quinto ','MA5AM','PE5AM','JM','Mecánica Automotriz','0007319958');
call sp_agregarPersona2(40146,'2021236','José Manolo','López Gregorio','Quinto ','MA5AM','PE5AM','JM','Mecánica Automotriz','0007282436');
call sp_agregarPersona2(40147,'2024042','Marvin Ismael','Lopez Perez','Quinto ','MA5AM','PE5AM','JM','Mecánica Automotriz','0007295077');
call sp_agregarPersona2(40148,'2021156','Jefferson Emanuel','Lux Chay','Quinto ','MA5AM','PE5AM','JM','Mecánica Automotriz','0007260119');
call sp_agregarPersona2(40149,'2021368','Criss Angel','Matheu Perez','Quinto ','MA5AM','PE5AM','JM','Mecánica Automotriz','0007284618');
call sp_agregarPersona2(40150,'2024126','Steven Fernando','Oliva Yumán','Quinto ','MA5AM','PE5AM','JM','Mecánica Automotriz','0007292898');
call sp_agregarPersona2(40151,'2024490','Diego Adolfo','Quiquivix Ortiz','Quinto ','MA5AM','PE5AM','JM','Mecánica Automotriz','0008008907');
call sp_agregarPersona2(40152,'2021127','Jose Luis','Reyes Lopez','Quinto ','MA5AM','PE5AM','JM','Mecánica Automotriz','0008026968');
call sp_agregarPersona2(40153,'2021128','Christian Marcelo José','Ruano Méndez','Quinto ','MA5AM','PE5AM','JM','Mecánica Automotriz','0008054222');
call sp_agregarPersona2(40154,'2021251','Nelson Alfonso','Tax Gutiérrez','Quinto ','MA5AM','PE5AM','JM','Mecánica Automotriz','0008076252');
call sp_agregarPersona2(40155,'2021357','Owen Oswaldo','Valenzuela Umaña','Quinto ','MA5AM','PE5AM','JM','Mecánica Automotriz','0007300834');
call sp_agregarPersona2(40156,'2023268','Nery Daniel','Zacarias Chamale','Quinto ','MA5AM','PE5AM','JM','Mecánica Automotriz','0007317722');
call sp_agregarPersona2(40157,'2024221','Didier Alessandro','Ruiz Monzón','Segundo','BA2DM','N/A','JM','Educación Básica','0005508219');
call sp_agregarPersona2(40158,'2023516','Dylan Steve','Barrera Jiménez','Segundo','BA2CM','N/A','JM','Educación Básica','0006597696');
call sp_agregarPersona2(40159,'2024067','JONATHAN FERNANDO','CARCAMO PIRIR','Segundo','BA2CM','N/A','JM','Educación Básica','0005399896');
call sp_agregarPersona2(40160,'2024487','José Javier','De león Argueta','Segundo','BA2CM','N/A','JM','Educación Básica','0005399834');
call sp_agregarPersona2(40161,'2024443','Pablo Sebastián','Moino Azañon','Segundo','BA2CM','N/A','JM','Educación Básica','0006609917');
call sp_agregarPersona2(40162,'2024492','Kyan Josue','López Recinos','Segundo','BA2BM','N/A','JM','Educación Básica','0005502880');
call sp_agregarPersona2(40163,'2023511','Ricardo Leonel','Sierra Castro','Segundo','BA2BM','N/A','JM','Educación Básica','0005617469');
call sp_agregarPersona2(40164,'2024344','Ian Daniel','Vicente Girón','Segundo','BA2BM','N/A','JM','Educación Básica','0005174854');
call sp_agregarPersona2(40165,'2024493','Yohandri Sebastian','Ramos Garcia','Segundo','BA2AM','N/A','JM','Educación Básica','0008096262');
call sp_agregarPersona2(40166,'2024210','MARCO LEONEL','JUÁREZ ALPÍREZ','Segundo','BA2AM','N/A','JM','Educación Básica','0003973541');
call sp_agregarPersona2(40167,'2024548','Samuel Isaac','Cuzco Sánchez','Segundo','BA2AM','N/A','JM','Educación Básica','0002849697');
call sp_agregarPersona2(40168,'2024134','Javier Andres','Barillas Zaldaña','Segundo','BA2AM','N/A','JM','Educación Básica','0001691375');
call sp_agregarPersona2(40169,'2024296','Edward joao','Velasquez alvarado','Segundo','BA2AM','N/A','JM','Educación Básica','0001596980');
call sp_agregarPersona2(40170,'2023592','Kevin Ricardo','Alvarado Cuarto','Tercero','BA3EM','N/A','JM','Educación Básica','0006845819');
call sp_agregarPersona2(40171,'2024407','Bayron Joel','Ascuc Coroy','Tercero','BA3DM','N/A','JM','Educación Básica','0001681437');
call sp_agregarPersona2(40172,'2023365','Cristian Marcoantonio','Hoffens Jacobo','Tercero','BA3BM','N/A','JM','Educación Básica','0007324297');
call sp_agregarPersona2(40173,'2021488','Byron Emmanuel','Ajcu Henrriquez','Quinto ','MA5BM','PE5CM','JM','Mecánica Automotriz','0007306363');
call sp_agregarPersona2(40174,'2024222','Steven Samuel','Alvarez Garcia','Quinto ','MA5BM','PE5CM','JM','Mecánica Automotriz','0007325892');
call sp_agregarPersona2(40175,'2021358','Jose Estuardo','Ceballos Valenzuela','Quinto ','MA5BM','PE5CM','JM','Mecánica Automotriz','0007285329');
call sp_agregarPersona2(40176,'2024093','Brayan Alexander','Culajay Franco','Quinto ','MA5BM','PE5CM','JM','Mecánica Automotriz','0007271911');
call sp_agregarPersona2(40177,'2021173','Keith Dylan','Gonzalez Arana','Quinto ','MA5BM','PE5CM','JM','Mecánica Automotriz','0007302025');
call sp_agregarPersona2(40178,'2024409','José Adrián','González Duarte','Quinto ','MA5BM','PE5CM','JM','Mecánica Automotriz','0007283557');
call sp_agregarPersona2(40179,'2021632','Jeremy Rafael','Gonzalez Ortiz','Quinto ','MA5BM','PE5CM','JM','Mecánica Automotriz','0007297665');
call sp_agregarPersona2(40180,'2021634','Guillermo Andres','Hernández Alvarez','Quinto ','MA5BM','PE5CM','JM','Mecánica Automotriz','0008067375');
call sp_agregarPersona2(40181,'2024013','Humberto Elias','Jorge Ramirez','Quinto ','MA5BM','PE5CM','JM','Mecánica Automotriz','0008033489');
call sp_agregarPersona2(40182,'2021646','Jeshua Ricardo Emanuel','Lopez Garcia','Quinto ','MA5BM','PE5CM','JM','Mecánica Automotriz','0005720925');
call sp_agregarPersona2(40183,'2023214','José Joel','López Guerra','Quinto ','MA5BM','PE5CM','JM','Mecánica Automotriz','0005731088');
call sp_agregarPersona2(40184,'2024005','Fernando Xavier','Lopez Oliva','Quinto ','MA5BM','PE5CM','JM','Mecánica Automotriz','0005731078');
call sp_agregarPersona2(40185,'2024158','Edison Alexander','Marroquín Cuxun','Quinto ','MA5BM','PE5CM','JM','Mecánica Automotriz','0005674770');
call sp_agregarPersona2(40186,'2021534','Gustavo Nicolas','Mazariegos Garcia','Quinto ','MA5BM','PE5CM','JM','Mecánica Automotriz','0005674775');
call sp_agregarPersona2(40187,'2024087','Javier Gerardo','Mejia Paz','Quinto ','MA5BM','PE5CM','JM','Mecánica Automotriz','0005730968');
call sp_agregarPersona2(40188,'2021523','Elmer Gabriel','Molinero Becerra','Quinto ','MA5BM','PE5CM','JM','Mecánica Automotriz','0005730963');
call sp_agregarPersona2(40189,'2023432','Lucas Gabriel','Morales Solorzano','Quinto ','MA5BM','PE5CM','JM','Mecánica Automotriz','0005719560');
call sp_agregarPersona2(40190,'2024397','Diego Geovany','Morán Blanco','Quinto ','MA5BM','PE5CM','JM','Mecánica Automotriz','0005719555');
call sp_agregarPersona2(40191,'2024123','José Angel','Nájera Salazar','Quinto ','MA5BM','PE5CM','JM','Mecánica Automotriz','0005719615');
call sp_agregarPersona2(40192,'2021389','Saúl Andrés','Ochoa Mauricio','Quinto ','MA5BM','PE5CM','JM','Mecánica Automotriz','0005722615');
call sp_agregarPersona2(40193,'2020345','John Marcus','Pec Estupe','Quinto ','MA5BM','PE5CM','JM','Mecánica Automotriz','0005664097');
call sp_agregarPersona2(40194,'2021563','Mario David','Pérez reyes','Quinto ','MA5BM','PE5CM','JM','Mecánica Automotriz','0007320670');
call sp_agregarPersona2(40195,'2024015','KEVIN FERNANDO','RAMÍREZ ROSALES','Quinto ','MA5BM','PE5CM','JM','Mecánica Automotriz','0007286550');
call sp_agregarPersona2(40196,'2024395','Marvin Gregorio','Subuyuj Tezén','Quinto ','MA5BM','PE5CM','JM','Mecánica Automotriz','0007298548');
call sp_agregarPersona2(40197,'2021269','Daniel Esteban','Tzoy Monterroso','Quinto ','MA5BM','PE5CM','JM','Mecánica Automotriz','0007319462');
call sp_agregarPersona2(40198,'2024207','Edgar Fernando','Azurdia García','Quinto ','EL5AM','PE5BM','JM','Electricidad Industrial','0007294846');
call sp_agregarPersona2(40199,'2024017','Axel Adolfo','Cotonón Chún','Quinto ','EL5AM','PE5BM','JM','Electricidad Industrial','0007258019');
call sp_agregarPersona2(40200,'2024446','Diego Enrique','de Leon Hernandez','Quinto ','EL5AM','PE5BM','JM','Electricidad Industrial','0007292345');
call sp_agregarPersona2(40201,'2021161','KEVIN ANDRÉ','GODÍNEZ GÓMEZ','Quinto ','EL5AM','PE5BM','JM','Electricidad Industrial','0007274305');
call sp_agregarPersona2(40202,'2024033','Gustavo Adolfo','Granados Vicente','Quinto ','EL5AM','PE5BM','JM','Electricidad Industrial','0007259604');
call sp_agregarPersona2(40203,'2024051','Ever-Aldo Nikolas D’Alessandro','Juárez Lemus','Quinto ','EL5AM','PE5BM','JM','Electricidad Industrial','0007247041');
call sp_agregarPersona2(40204,'2021126','Diego Alejandro','López Chávez','Quinto ','EL5AM','PE5BM','JM','Electricidad Industrial','0007275864');
call sp_agregarPersona2(40205,'2021273','Isaías Efrain','Méndez Velásquez','Quinto ','EL5AM','PE5BM','JM','Electricidad Industrial','0007292340');
call sp_agregarPersona2(40206,'2021702','Luis José','Pablo Cerrato','Quinto ','EL5AM','PE5BM','JM','Electricidad Industrial','0007274906');
call sp_agregarPersona2(40207,'2024530','Josué Rafael','Palacios Aldana','Quinto ','EL5AM','PE5BM','JM','Electricidad Industrial','0007256002');
call sp_agregarPersona2(40208,'2024393','Diego Eduardo','Palencia Mejia','Quinto ','EL5AM','PE5BM','JM','Electricidad Industrial','0007245448');
call sp_agregarPersona2(40209,'2024172','Carlos Alejandro','Quijivix Alvarado','Quinto ','EL5AM','PE5BM','JM','Electricidad Industrial','0007333433');
call sp_agregarPersona2(40210,'2020597','Jessel Andres','Ralón Guzmán','Quinto ','EL5AM','PE5BM','JM','Electricidad Industrial','0007329562');
call sp_agregarPersona2(40211,'2024064','Andersson Juan Manuel','Raxic Cortez','Quinto ','EL5AM','PE5BM','JM','Electricidad Industrial','0004743754');
call sp_agregarPersona2(40212,'2021144','Luis Emanuel','Reyes Colindrez','Quinto ','EL5AM','PE5BM','JM','Electricidad Industrial','0004743749');
call sp_agregarPersona2(40213,'2021012','Jheremy Adolfo','Trujillo Salazar','Quinto ','EL5AM','PE5BM','JM','Electricidad Industrial','0004743744');
call sp_agregarPersona2(40214,'2021160','José joaquín','ajcabul esturban','Quinto ','IN5BM','PE5EM','JM','Computación','0007270878');
call sp_agregarPersona2(40215,'2024004','Adrian Rafael','Alvarez Marín','Quinto ','IN5BM','PE5EM','JM','Computación','0007319219');
call sp_agregarPersona2(40216,'2021159','Jorge Eliam','Aquino Reyes','Quinto ','IN5BM','PE5EM','JM','Computación','0005524243');
call sp_agregarPersona2(40217,'2024203','Alejandro José','Arocha Virula','Quinto ','IN5BM','PE5EM','JM','Computación','0005505349');
call sp_agregarPersona2(40218,'2021547','Pablo David','Calderón Castellón','Quinto ','IN5BM','PE5EM','JM','Computación','0005505346');
call sp_agregarPersona2(40219,'2021639','Rhandy Estuardo','Caná Subuyuj','Quinto ','IN5BM','PE5EM','JM','Computación','0005505339');
call sp_agregarPersona2(40220,'2021560','Carlos Daniel','Chacón Duarte','Quinto ','IN5BM','PE5EM','JM','Computación','0005505199');
call sp_agregarPersona2(40221,'2024037','Juan Diego','Coyote Mactzul','Quinto ','IN5BM','PE5EM','JM','Computación','0005704523');
call sp_agregarPersona2(40222,'2021644','Jefry André','Cruz Yumán','Quinto ','IN5BM','PE5EM','JM','Computación','0005733438');
call sp_agregarPersona2(40223,'2024028','Edvin Leonel','Cujcuj Ejcalón','Quinto ','IN5BM','PE5EM','JM','Computación','0005733432');
call sp_agregarPersona2(40224,'2021660','Oscar Sebastian','Cumatz López','Quinto ','IN5BM','PE5EM','JM','Computación','0005733427');
call sp_agregarPersona2(40225,'2021364','Pablo Andrés','De León Rashon','Quinto ','IN5BM','PE5EM','JM','Computación','0005741581');
call sp_agregarPersona2(40226,'2021545','Erick Mauricio','Folgar Alarcon','Quinto ','IN5BM','PE5EM','JM','Computación','0005667654');
call sp_agregarPersona2(40227,'2021647','Josue Gilberto','Jimenez Ajtun','Quinto ','IN5BM','PE5EM','JM','Computación','0005667659');
call sp_agregarPersona2(40228,'2024010','Alan Francisco','Lacán Flores','Quinto ','IN5BM','PE5EM','JM','Computación','0005727829');
call sp_agregarPersona2(40229,'2021019','Milton Angel Daniel','Lara Lopez','Quinto ','IN5BM','PE5EM','JM','Computación','0005727825');
call sp_agregarPersona2(40230,'2024029','Jorge Lisandro','Magzul Tzuquén','Quinto ','IN5BM','PE5EM','JM','Computación','0005730461');
call sp_agregarPersona2(40231,'2024032','Cristopher Daniel','Martínez Saquic','Quinto ','IN5BM','PE5EM','JM','Computación','0005693723');
call sp_agregarPersona2(40232,'2021550','Jeremy Jhoel','Mendez Palencia','Quinto ','IN5BM','PE5EM','JM','Computación','0005693714');
call sp_agregarPersona2(40233,'2021528','Sebastian Alejandro','Molina Herrera','Quinto ','IN5BM','PE5EM','JM','Computación','0005693707');
call sp_agregarPersona2(40234,'2021265','Sebastian André','Oxcal Florian','Quinto ','IN5BM','PE5EM','JM','Computación','0005693704');
call sp_agregarPersona2(40235,'2024003','Iverson Armando','Pérez Maldonado','Quinto ','IN5BM','PE5EM','JM','Computación','0005721089');
call sp_agregarPersona2(40236,'2021274','Franklin Alejandro','Pineda Garrido','Quinto ','IN5BM','PE5EM','JM','Computación','0005721083');
call sp_agregarPersona2(40237,'2024040','Xavier Alejandro','Portillo Estrada','Quinto ','IN5BM','PE5EM','JM','Computación','0005696844');
call sp_agregarPersona2(40238,'2021262','Santiago','Quezada Reyes','Quinto ','IN5BM','PE5EM','JM','Computación','0005696840');
call sp_agregarPersona2(40239,'2021549','Julio Gabriel','Realiquez Noriega','Quinto ','IN5BM','PE5EM','JM','Computación','0005670377');
call sp_agregarPersona2(40240,'2021564','Joab Alejandro','Regil Selvi','Quinto ','IN5BM','PE5EM','JM','Computación','0005670374');
call sp_agregarPersona2(40241,'2023342','Roberto Andre','Rodriguez Gonzalez','Quinto ','IN5BM','PE5EM','JM','Computación','0005722398');
call sp_agregarPersona2(40242,'2024082','Angel Emmanuel Fiorentin','Roquel Acuta','Quinto ','IN5BM','PE5EM','JM','Computación','0005722393');
call sp_agregarPersona2(40243,'2021462','Hugo Benjamín','Samayoa Díaz','Quinto ','IN5BM','PE5EM','JM','Computación','0008028555');
call sp_agregarPersona2(40244,'2024254','Joshua Alejandro','Santa Cruz Chicas','Quinto ','IN5BM','PE5EM','JM','Computación','0007303882');
call sp_agregarPersona2(40245,'2024520','Eddy Fernando','alvarado Cuarto','Quinto ','MA5BV','PE5DV','JV','Mecánica Automotriz','0007302043');
call sp_agregarPersona2(40246,'2024233','Henry Oswaldo','Cermeño Nájera','Quinto ','MA5BV','PE5DV','JV','Mecánica Automotriz','0007294324');
call sp_agregarPersona2(40247,'2024484','Juan Ignacio Santiago','Cutzal Sicay','Quinto ','MA5BV','PE5DV','JV','Mecánica Automotriz','0007304250');
call sp_agregarPersona2(40248,'2024255','Vinicio Alexander','Gramajo Chum','Quinto ','MA5BV','PE5DV','JV','Mecánica Automotriz','0008076362');
call sp_agregarPersona2(40249,'2024408','Matthew Harry Mario','Hernández Chacón','Quinto ','MA5BV','PE5DV','JV','Mecánica Automotriz','0008050378');
call sp_agregarPersona2(40250,'2024334','Luis Fernando','Macario Zet','Quinto ','MA5BV','PE5DV','JV','Mecánica Automotriz','0007285732');
call sp_agregarPersona2(40251,'2024291','Edwin Conrado','Orellana Rodas','Quinto ','MA5BV','PE5DV','JV','Mecánica Automotriz','0007278883');
call sp_agregarPersona2(40252,'2024411','Matheo Alejandro','Penagos Zamora','Quinto ','MA5BV','PE5DV','JV','Mecánica Automotriz','0007261368');
call sp_agregarPersona2(40253,'2024341','CHRISTIAN SAMUEL ALBERTO','PEREZ GARCIA','Quinto ','MA5BV','PE5DV','JV','Mecánica Automotriz','0007271660');
call sp_agregarPersona2(40254,'2024216','Jefferson Roberto','Pirir Herrera','Quinto ','MA5BV','PE5DV','JV','Mecánica Automotriz','0007253186');
call sp_agregarPersona2(40255,'2024288','Josué Alexander','Ramírez Hernández','Quinto ','MA5BV','PE5DV','JV','Mecánica Automotriz','0007289134');
call sp_agregarPersona2(40256,'2024440','Gustavo Alberto','Rodas Ixtuc','Quinto ','MA5BV','PE5DV','JV','Mecánica Automotriz','0007264897');
call sp_agregarPersona2(40257,'2024103','Misael Estuardo','Saban Saban','Quinto ','MA5BV','PE5DV','JV','Mecánica Automotriz','0007258067');
call sp_agregarPersona2(40258,'2024232','Jordi Estuardo','Santizo Garcia','Quinto ','MA5BV','PE5DV','JV','Mecánica Automotriz','0007268418');
call sp_agregarPersona2(40259,'2024351','Abner Ismael','Sequen Ramirez','Quinto ','MA5BV','PE5DV','JV','Mecánica Automotriz','0007242215');
call sp_agregarPersona2(40260,'2024406','Pablo Andres','Sotz Miza','Quinto ','MA5BV','PE5DV','JV','Mecánica Automotriz','0007258873');
call sp_agregarPersona2(40261,'2024273','Luis Fernando','Tello Calel','Quinto ','MA5BV','PE5DV','JV','Mecánica Automotriz','0007264077');
call sp_agregarPersona2(40262,'2023312','Juan Manuel','Torres Bailón','Quinto ','MA5BV','PE5DV','JV','Mecánica Automotriz','0007283252');
call sp_agregarPersona2(40263,'2024065','Marco Sebastian','Vela Velasquez','Quinto ','MA5BV','PE5DV','JV','Mecánica Automotriz','0007265501');
call sp_agregarPersona2(40264,'2024156','Oscar Gabriel','Zuñiga Alvarez','Quinto ','MA5BV','PE5DV','JV','Mecánica Automotriz','0007287916');
call sp_agregarPersona2(40265,'2024315','LUIS PEDRO','ALAY LOPEZ','Quinto ','IN5BV','PE5BV','JV','Computación','0007334419');
call sp_agregarPersona2(40266,'2024386','Jeferson André','Cano López','Quinto ','IN5BV','PE5CV','JV','Computación','0007296720');
call sp_agregarPersona2(40267,'2024310','Ricardo Alejandro','Hernández Hernández','Quinto ','IN5BV','PE5BV','JV','Computación','0007290264');
call sp_agregarPersona2(40268,'2024332','Dany Ixbalanquè','Lucas Vicente','Quinto ','IN5BV','PE5BV','JV','Computación','0007257525');
call sp_agregarPersona2(40269,'2024356','Francisco Emanuel','Milian Gonzalez','Quinto ','IN5BV','PE5BV','JV','Computación','0007250254');
call sp_agregarPersona2(40270,'2021543','Diego Alejandro','Monterroso Domínguez','Quinto ','IN5BV','PE5BV','JV','Computación','0007292627');
call sp_agregarPersona2(40271,'2024279','Moises Eduardo','Morales Alvizures','Quinto ','IN5BV','PE5BV','JV','Computación','0007265249');
call sp_agregarPersona2(40272,'2024264','Franklin Stev','Paiz Chavez','Quinto ','IN5BV','PE5BV','JV','Computación','0005569162');
call sp_agregarPersona2(40273,'2024357','Marlon Eduardo','Pérez Moreira','Quinto ','IN5BV','PE5BV','JV','Computación','0005569167');
call sp_agregarPersona2(40274,'2024250','Eduardo André','Rodríguez Ochoa','Quinto ','IN5BV','PE5CV','JV','Computación','0005569173');
call sp_agregarPersona2(40275,'2024380','Josue David','Sajche Boror','Quinto ','IN5BV','PE5CV','JV','Computación','0005558407');
call sp_agregarPersona2(40276,'2024318','OSCAR RODOLFO ABRAHAM','SICAJAU MÉRIDA','Quinto ','IN5BV','PE5CV','JV','Computación','0005558413');
call sp_agregarPersona2(40277,'2024328','Crhistian Antonio','Sican Paredes','Quinto ','IN5BV','PE5CV','JV','Computación','0007325918');
call sp_agregarPersona2(40278,'2024342','Angel David','Siliezar López','Quinto ','IN5BV','PE5CV','JV','Computación','0007327380');
call sp_agregarPersona2(40279,'2024295','Isaac','Tiguilá Véliz','Quinto ','IN5BV','PE5CV','JV','Computación','0007334375');
call sp_agregarPersona2(40280,'2024458','Kenny Noe','Angel Ignacio','Quinto ','IN5CV','PE5BV','JV','Computación','0007301964');
call sp_agregarPersona2(40281,'2024412','Marcos Javier','García Cruz','Quinto ','IN5CV','PE5BV','JV','Computación','0007318196');
call sp_agregarPersona2(40282,'2024445','Jossé Ricardo','Hernández Díaz','Quinto ','IN5CV','PE5BV','JV','Computación','0007274378');
call sp_agregarPersona2(40283,'2024047','Emiliano Sebastian','Herrera Galdamez','Quinto ','IN5CV','PE5BV','JV','Computación','0007266880');
call sp_agregarPersona2(40284,'2024401','Kevin Ritter Calvin','López Aceytuno','Quinto ','IN5CV','PE5BV','JV','Computación','0007254123');
call sp_agregarPersona2(40285,'2023241','Zimri Jahdai','López Miranda','Quinto ','IN5CV','PE5BV','JV','Computación','0007251373');
call sp_agregarPersona2(40286,'2024449','Anderson Marco Miguel','Sosa Balcarcel','Quinto ','IN5CV','PE5CV','JV','Computación','0007261151');
call sp_agregarPersona2(40287,'2021211','Angel Fernando','Lucero León','Quinto ','IN5CV','PE5BV','JV','Computación','0007271929');
call sp_agregarPersona2(40288,'2024433','Denis Rafael','Morales Tote','Quinto ','IN5CV','PE5BV','JV','Computación','0007295803');
call sp_agregarPersona2(40289,'2024399','Kevin Estuardo','Ramírez Aguirre','Quinto ','IN5CV','PE5CV','JV','Computación','0007241977');
call sp_agregarPersona2(40290,'2024396','Billy Adrián','Reyes López','Quinto ','IN5CV','PE5BV','JV','Computación','0007247591');
call sp_agregarPersona2(40291,'2024422','Saul de Jesús','Sical Yoc','Quinto ','IN5CV','PE5CV','JV','Computación','0007294383');
call sp_agregarPersona2(40292,'2021691','IOSEF','SUAREZ GIL','Quinto ','IN5CV','PE5CV','JV','Computación','0007305546');
call sp_agregarPersona2(40293,'2024505','Eddy Daniel','Tucubal Sacbajá','Quinto ','IN5CV','PE5CV','JV','Computación','0007296347');
call sp_agregarPersona2(40294,'2024060','Roger Steven','Valladares Pineda','Quinto ','IN5CV','PE5CV','JV','Computación','0007289565');
call sp_agregarPersona2(40295,'2024442','Jeferson Gustavo Antonio','Yaxón Ixcayà','Quinto ','IN5CV','PE5CV','JV','Computación','0007305248');
call sp_agregarPersona2(40296,'2024452','José Fernando','Zeta Galeano','Quinto ','IN5CV','PE5CV','JV','Computación','0007282962');
call sp_agregarPersona2(40297,'2024152','Manases Emanuel','Antuche Xol','Quinto ','DB5AV','PE5AV','JV','Dibujo Técnico','0007327409');
call sp_agregarPersona2(40298,'2024378','Gabriel','Apen Cumez','Quinto ','DB5AV','PE5AV','JV','Dibujo Técnico','0007313813');
call sp_agregarPersona2(40299,'2024214','Oseas Jezreel','Batres Myvett','Quinto ','DB5AV','PE5AV','JV','Dibujo Técnico','0007323508');
call sp_agregarPersona2(40300,'2024181','Cesar David','Chaperón Toj','Quinto ','DB5AV','PE5AV','JV','Dibujo Técnico','0007317638');
call sp_agregarPersona2(40301,'2024477','Julio David','Díaz Villatoro','Quinto ','DB5AV','PE5AV','JV','Dibujo Técnico','0007275833');
call sp_agregarPersona2(40302,'2024191','Oscar Arturo','Escobar Escobar','Quinto ','DB5AV','PE5AV','JV','Dibujo Técnico','0007262708');
call sp_agregarPersona2(40303,'2024195','MARIO JULIAN','HERNANDEZ BLANCO','Quinto ','DB5AV','PE5AV','JV','Dibujo Técnico','0007247008');
call sp_agregarPersona2(40304,'2024491','Mario Alexander','Hernández Chiquiej','Quinto ','DB5AV','PE5AV','JV','Dibujo Técnico','0007281272');
call sp_agregarPersona2(40305,'2024256','Christopher Alejandro','Hernández Morente','Quinto ','DB5AV','PE5AV','JV','Dibujo Técnico','0007303937');
call sp_agregarPersona2(40306,'2021258','Luis Alfredo','López Miranda','Quinto ','DB5AV','PE5AV','JV','Dibujo Técnico','0007255460');
call sp_agregarPersona2(40307,'2024268','JOHANN ANDRE','MINERA GARCIA','Quinto ','DB5AV','PE5AV','JV','Dibujo Técnico','0007271391');
call sp_agregarPersona2(40308,'2024162','Cesar Augusto','Noj Sian','Quinto ','DB5AV','PE5AV','JV','Dibujo Técnico','0007290240');
call sp_agregarPersona2(40309,'2024120','Diego Alejandro','Rosales Gudiel','Quinto ','DB5AV','PE5AV','JV','Dibujo Técnico','0007320152');
call sp_agregarPersona2(40310,'2024173','José Manuel','Zuñiga Chacón','Quinto ','DB5AV','PE5AV','JV','Dibujo Técnico','0007260758');
call sp_agregarPersona2(40311,'2024100','Jose Enrique','Cuc Cutz','Quinto ','IN5AV','PE5AV','JV','Computación','0007255604');
call sp_agregarPersona2(40312,'2024177','Kenet Efraín','Cuyuch Joj','Quinto ','IN5AV','PE5AV','JV','Computación','0007275725');
call sp_agregarPersona2(40313,'2024243','Wilson Adrian','Del Cid Pasan','Quinto ','IN5AV','PE5AV','JV','Computación','0007283368');
call sp_agregarPersona2(40314,'2024242','Carlos Enrique','López Quino','Quinto ','IN5AV','PE5AV','JV','Computación','0007257159');
call sp_agregarPersona2(40315,'2024231','Ricardo André','Marroquín López','Quinto ','IN5AV','PE5AV','JV','Computación','0007274540');
call sp_agregarPersona2(40316,'2024083','JEREMY JORGE AARON','MARTINEZ ZAMORA','Quinto ','IN5AV','PE5AV','JV','Computación','0007255083');
call sp_agregarPersona2(40317,'2024155','Luis Eduardo','Montenegro Rivera','Quinto ','IN5AV','PE5AV','JV','Computación','0007269742');
call sp_agregarPersona2(40318,'2024170','Carlos Emilio','Navarro Sifontes','Quinto ','IN5AV','PE5AV','JV','Computación','0007287100');
call sp_agregarPersona2(40319,'2024102','Angel Gahel','Padilla Pacheco','Quinto ','IN5AV','PE5AV','JV','Computación','0007320110');
call sp_agregarPersona2(40320,'2024240','Javier Eduardo','Paredes Flores','Quinto ','IN5AV','PE5AV','JV','Computación','0007313416');
call sp_agregarPersona2(40321,'2024136','Carlos Alejandro','Patal Choc','Quinto ','IN5AV','PE5AV','JV','Computación','0007247840');
call sp_agregarPersona2(40322,'2024226','Diego Alejandro','Velásquez Cuté','Quinto ','IN5AV','PE5AV','JV','Computación','0007265251');
call sp_agregarPersona2(40323,'2024388','Héber Joel','Pirir Reyes','Quinto ','EB5AV','PE5CV','JV','Electrónica básica','0005664102');
call sp_agregarPersona2(40324,'2024324','José Sebastián','Polanco Sotomayor','Quinto ','EB5AV','PE5CV','JV','Electrónica básica','0005664107');
call sp_agregarPersona2(40325,'2024447','Angel Ismael','Romero Boror','Quinto ','EB5AV','PE5CV','JV','Electrónica básica','0005719952');
call sp_agregarPersona2(40326,'2024384','Cristian Alexander','Samayoa Méndez','Quinto ','EB5AV','PE5CV','JV','Electrónica básica','0005719957');
call sp_agregarPersona2(40327,'2024269','Javier Alejandro','Síque Lemus','Quinto ','EB5AV','PE5CV','JV','Electrónica básica','0005680642');
call sp_agregarPersona2(40328,'2024430','Estuardo Daniel','Soyos Picholá','Quinto ','EB5AV','PE5CV','JV','Electrónica básica','0007284805');
call sp_agregarPersona2(40329,'2024350','Gadiel Alexander','Tucubal Guitz','Quinto ','EB5AV','PE5CV','JV','Electrónica básica','0007291525');
call sp_agregarPersona2(40330,'2023363','DANIEL ISAAC','CASTELLANOS ESTRADA','Quinto ','EB5AV','PE5CV','JV','Electrónica básica','0007324897');
call sp_agregarPersona2(40331,'2024466','Henry David Antonio','Castillo Palencia','Quinto ','EB5AV','PE5CV','JV','Electrónica básica','0007310916');
call sp_agregarPersona2(40332,'2024379','JOSHUA DANIEL','DÍAZ PINEDA','Quinto ','EB5AV','PE5CV','JV','Electrónica básica','0007257687');
call sp_agregarPersona2(40333,'2024373','Gabriel Alejandro','Esquivel','Quinto ','EB5AV','PE5CV','JV','Electrónica básica','0007273936');
call sp_agregarPersona2(40334,'2023222','Luis Enrique Ricardo','Garrido Aguilar','Quinto ','EB5AV','PE5CV','JV','Electrónica básica','0007276203');
call sp_agregarPersona2(40335,'2024278','Brayan Antonio','Gil Argueta','Quinto ','EB5AV','PE5CV','JV','Electrónica básica','0007261394');
call sp_agregarPersona2(40336,'2024460','Ángel Renato','Hernández Grijalva','Quinto ','EB5AV','PE5CV','JV','Electrónica básica','0007244774');
call sp_agregarPersona2(40337,'2024217','Francisco André','Martínez Dieguez','Quinto ','EB5AV','PE5CV','JV','Electrónica básica','0007256754');
call sp_agregarPersona2(40338,'2024502','JOSÉ PABLO','ORELLANA ROMÁN','Quinto ','EB5AV','PE5CV','JV','Electrónica básica','0007310527');
call sp_agregarPersona2(40339,'2024293','Pedro Saúl','Avalos Pur','Quinto ','EL5AV','PE5DV','JV','Electricidad Industrial','0007250005');
call sp_agregarPersona2(40340,'2024241','Gustavo Adolfo','Corado Artiga','Quinto ','EL5AV','PE5DV','JV','Electricidad Industrial','0007327778');
call sp_agregarPersona2(40341,'2021478','Carlos Daniel','Quino Och','Quinto ','EL5AV','PE5DV','JV','Electricidad Industrial','0007305217');
call sp_agregarPersona2(40342,'2024517','Gustavo André','Romero López','Quinto ','EL5AV','PE5DV','JV','Electricidad Industrial','0007267594');
call sp_agregarPersona2(40343,'2022175','Manuel','Anzueto Rodas','Quinto ','MA5AV','PE5BV','JV','Mecánica Automotriz','0007271741');
call sp_agregarPersona2(40344,'2021143','Luis Fernando Javier','Cifuentes Morales','Quinto ','MA5AV','PE5BV','JV','Mecánica Automotriz','0005569163');
call sp_agregarPersona2(40345,'2021263','Juan Pablo','Gómez Paredes','Quinto ','MA5AV','PE5BV','JV','Mecánica Automotriz','0005569168');
call sp_agregarPersona2(40346,'2021494','Sergio Alejandro','Gonzalez Monzón','Quinto ','MA5AV','PE5BV','JV','Mecánica Automotriz','0005569174');
call sp_agregarPersona2(40347,'2021650','Nathan Javier','López Pablo','Quinto ','MA5AV','PE5BV','JV','Mecánica Automotriz','0005558408');
call sp_agregarPersona2(40348,'2024202','Angel Roberto','Paz Henríquez','Quinto ','MA5AV','PE5BV','JV','Mecánica Automotriz','0005558414');
call sp_agregarPersona2(40349,'2024220','Alexander Sebastian','Salas Manzo','Quinto ','MA5AV','PE5BV','JV','Mecánica Automotriz','0007316657');
call sp_agregarPersona2(40350,'2021376','Jhon Sebastián','Salvador Santiago','Quinto ','MA5AV','PE5BV','JV','Mecánica Automotriz','0007327593');
call sp_agregarPersona2(40351,'2024353','Gerson Antonio','Sequén Pórix','Quinto ','MA5AV','PE5BV','JV','Mecánica Automotriz','0007332823');
call sp_agregarPersona2(40352,'2024131','Marlon Isaac','Sontay Patzán','Quinto ','MA5AV','PE5BV','JV','Mecánica Automotriz','0007296107');
call sp_agregarPersona2(40353,'2024402','Elmer Abimael','Vásquez Vásquez','Quinto ','MA5AV','PE5BV','JV','Mecánica Automotriz','0007310446');
call sp_agregarPersona2(40354,'2021386','Carlos Fernando','Vega Aroche','Quinto ','MA5AV','PE5BV','JV','Mecánica Automotriz','0007281120');
call sp_agregarPersona2(40355,'2020278','Anthony Alexander','Blanco Luna','Sexto','MA6AM','PE6AM','JM','Mecánica Automotriz','0007297405');
call sp_agregarPersona2(40356,'2020086','Javier Augusto','Cabrera Velásquez','Sexto','MA6AM','PE6AM','JM','Mecánica Automotriz','0007279791');
call sp_agregarPersona2(40357,'2023245','José David','Carrillo Asencio','Sexto','MA6AM','PE6AM','JM','Mecánica Automotriz','0007282617');
call sp_agregarPersona2(40358,'2020364','Miguel Enrique','Castellanos Zapeta','Sexto','MA6AM','PE6AM','JM','Mecánica Automotriz','0007301440');
call sp_agregarPersona2(40359,'2023272','Kevin Alexander','Cervantes Flores','Sexto','MA6AM','PE6AM','JM','Mecánica Automotriz','0007271010');
call sp_agregarPersona2(40360,'2021381','Antoni Uriel','de León Morales','Sexto','MA6AM','PE6AM','JM','Mecánica Automotriz','0007317887');
call sp_agregarPersona2(40361,'2019271','Carlos Alberto','Escobar García','Sexto','MA6AM','PE6AM','JM','Mecánica Automotriz','0007332482');
call sp_agregarPersona2(40362,'2020268','Cristian Alexander','Fuentes Azurdia','Sexto','MA6AM','PE6AM','JM','Mecánica Automotriz','0007327762');
call sp_agregarPersona2(40363,'2020361','Cesar Andres','García Chew','Sexto','MA6AM','PE6AM','JM','Mecánica Automotriz','0007319969');
call sp_agregarPersona2(40364,'2020496','Jose Carlos','Jeréz Gómez','Sexto','MA6AM','PE6AM','JM','Mecánica Automotriz','0007296712');
call sp_agregarPersona2(40365,'2020001','Hugo Rafael','Monroy Donis','Sexto','MA6AM','PE6AM','JM','Mecánica Automotriz','0007289520');
call sp_agregarPersona2(40366,'2023228','Juan Carlos','Montenegro Juarez','Sexto','MA6AM','PE6AM','JM','Mecánica Automotriz','0007276879');
call sp_agregarPersona2(40367,'2023424','Marco Javier','Morales Gómez','Sexto','MA6AM','PE6AM','JM','Mecánica Automotriz','0007259837');
call sp_agregarPersona2(40368,'2020476','José Rodrigo','Najarro Rodríguez','Sexto','MA6AM','PE6AM','JM','Mecánica Automotriz','0007320349');
call sp_agregarPersona2(40369,'2023187','Harol David','Osorio Ixpata','Sexto','MA6AM','PE6AM','JM','Mecánica Automotriz','0007302004');
call sp_agregarPersona2(40370,'2020192','Ricardo Alberto','Ruiz Castellanos','Sexto','MA6AM','PE6AM','JM','Mecánica Automotriz','0007331850');
call sp_agregarPersona2(40371,'2020248','José Daniel','Velásquez Chávez','Sexto','MA6AM','PE6AM','JM','Mecánica Automotriz','0007266191');
call sp_agregarPersona2(40372,'2020482','Daniel Enrique','Xitumul Cruz','Sexto','MA6AM','PE6AM','JM','Mecánica Automotriz','0007242590');
call sp_agregarPersona2(40373,'2023103','Jhostyn Alexander','Álvarez Rivera','Sexto','MA6BM','PE6BM','JM','Mecánica Automotriz','0007282953');
call sp_agregarPersona2(40374,'2019196','Josemaria Rafael','Chanquín Mateo','Sexto','MA6BM','PE6BM','JM','Mecánica Automotriz','0007242032');
call sp_agregarPersona2(40375,'2023138','Angel Antonio','Cifuentes Cano','Sexto','MA6BM','PE6BM','JM','Mecánica Automotriz','0007266066');
call sp_agregarPersona2(40376,'2023169','Bryan Isai','Contreras Gómez','Sexto','MA6BM','PE6BM','JM','Mecánica Automotriz','0007281351');
call sp_agregarPersona2(40377,'2020326','David Manolo','Fernández Lutín','Sexto','MA6BM','PE6BM','JM','Mecánica Automotriz','0007299575');
call sp_agregarPersona2(40378,'2023092','BRYAN IVAN','GALICIA SANTOS','Sexto','MA6BM','PE6BM','JM','Mecánica Automotriz','0007296425');
call sp_agregarPersona2(40379,'2021645','Marcos Emilio','Galvez Flores','Sexto','MA6BM','PE6DM','JM','Mecánica Automotriz','0007308797');
call sp_agregarPersona2(40380,'2023127','Javier Alejandro','Godínez Herrera','Sexto','MA6BM','PE6DM','JM','Mecánica Automotriz','0007288858');
call sp_agregarPersona2(40381,'2019283','Adrian Josué','Guevara Almendarez','Sexto','MA6BM','PE6DM','JM','Mecánica Automotriz','0007279227');
call sp_agregarPersona2(40382,'2023240','Carlos Alberto','Guevara Rodriguez','Sexto','MA6BM','PE6DM','JM','Mecánica Automotriz','0007305211');
call sp_agregarPersona2(40383,'2023403','Walter Alejandro','Lix Juarez','Sexto','MA6BM','PE6BM','JM','Mecánica Automotriz','0007272336');
call sp_agregarPersona2(40384,'2020510','Pablo José Antonio','López Carrillo','Sexto','MA6BM','PE6DM','JM','Mecánica Automotriz','0007255905');
call sp_agregarPersona2(40385,'2023520','Rodrigo Antonio','Mayen Pocasangre','Sexto','MA6BM','PE6DM','JM','Mecánica Automotriz','0007268758');
call sp_agregarPersona2(40386,'2023192','Diego Alexander','Muralles Rivera','Sexto','MA6BM','PE6DM','JM','Mecánica Automotriz','0007282014');
call sp_agregarPersona2(40387,'2023096','Fernando Emmanuel','Ortíz Avila','Sexto','MA6BM','PE6DM','JM','Mecánica Automotriz','0007243522');
call sp_agregarPersona2(40388,'2023142','Marcos Andre','Ortiz Montiel','Sexto','MA6BM','PE6DM','JM','Mecánica Automotriz','0007295899');
call sp_agregarPersona2(40389,'2023123','Jeferson Bayano','Pérez Teodoro','Sexto','MA6BM','PE6DM','JM','Mecánica Automotriz','0007256848');
call sp_agregarPersona2(40390,'2023109','Arturo Vitalino','Rac Pérez','Sexto','MA6BM','PE6DM','JM','Mecánica Automotriz','0007282020');
call sp_agregarPersona2(40391,'2020492','Demetrio','Ramírez Díaz','Sexto','MA6BM','PE6DM','JM','Mecánica Automotriz','0007267288');
call sp_agregarPersona2(40392,'2023306','Edwin Noé','Ramírez Toj','Sexto','MA6BM','PE6DM','JM','Mecánica Automotriz','0007251259');
call sp_agregarPersona2(40393,'2023058','Juan Antonio','Revolorio Huarcas','Sexto','MA6BM','PE6DM','JM','Mecánica Automotriz','0007242589');
call sp_agregarPersona2(40394,'2023071','Juan José Emanuel','Sipac Ajuchán','Sexto','MA6BM','PE6DM','JM','Mecánica Automotriz','0007331672');
call sp_agregarPersona2(40395,'2021353','JULIO RENE','ALVARADO HERRERA','Sexto','IN6AM','PE6BM','JM','Computación','0008051226');
call sp_agregarPersona2(40396,'2020444','José André','Arrecis Vargas','Sexto','IN6AM','PE6BM','JM','Computación','0008016785');
call sp_agregarPersona2(40397,'2020316','Juan Pablo','Barrera Delgado','Sexto','IN6AM','PE6BM','JM','Computación','0008023422');
call sp_agregarPersona2(40398,'2020306','Christopher Steve','Barrera Mazariegos','Sexto','IN6AM','PE6BM','JM','Computación','0008051681');
call sp_agregarPersona2(40399,'2020375','Miguel Angel','Bautista García','Sexto','IN6AM','PE6BM','JM','Computación','0008019683');
call sp_agregarPersona2(40400,'2020413','Alexander David','Borja Mena','Sexto','IN6AM','PE6BM','JM','Computación','0008033221');
call sp_agregarPersona2(40401,'2020531','Diego Alejandro','Caal Hernández','Sexto','IN6AM','PE6BM','JM','Computación','0008010897');
call sp_agregarPersona2(40402,'2020415','Hettson Enrique','Ceballos Alcalán','Sexto','IN6AM','PE6BM','JM','Computación','0007986352');
call sp_agregarPersona2(40403,'2020280','Ricardo Alejandro','Galindo Yani','Sexto','IN6AM','PE6BM','JM','Computación','0008032167');
call sp_agregarPersona2(40404,'2020363','Enmanuel Isaias','García Baran','Sexto','IN6AM','PE6BM','JM','Computación','0007992891');
call sp_agregarPersona2(40405,'2020322','Luis Antonio','García Morales','Sexto','IN6AM','PE6BM','JM','Computación','0008035284');
call sp_agregarPersona2(40406,'2020336','Keneth Alexander','García Rodríguez','Sexto','IN6AM','PE6DM','JM','Computación','0008020171');
call sp_agregarPersona2(40407,'2020088','Sergio Daniel','Gómez Chico','Sexto','IN6AM','PE6DM','JM','Computación','0008053941');
call sp_agregarPersona2(40408,'2020370','Jonathan Enmanuel','Gutierrez Godoy','Sexto','IN6AM','PE6DM','JM','Computación','0008012707');
call sp_agregarPersona2(40409,'2020477','Juan David','Hernández Godínez','Sexto','IN6AM','PE6DM','JM','Computación','0007257243');
call sp_agregarPersona2(40410,'2020416','Daniel Alejandro','Hernández Reyes','Sexto','IN6AM','PE6DM','JM','Computación','0007252039');
call sp_agregarPersona2(40411,'2023001','Angel David','Noj Mazariegos','Sexto','IN6AM','PE6DM','JM','Computación','0007303490');
call sp_agregarPersona2(40412,'2020299','José Javier','Oroxón Ixchop','Sexto','IN6AM','PE6DM','JM','Computación','0007328765');
call sp_agregarPersona2(40413,'2020405','Juan Sebastian','Ortigoza Cheley','Sexto','IN6AM','PE6DM','JM','Computación','0007278208');
call sp_agregarPersona2(40414,'2020067','Alan Steve','Pérez Rodas','Sexto','IN6AM','PE6DM','JM','Computación','0007294888');
call sp_agregarPersona2(40415,'2020285','Jose Miguel','Pirir Pérez','Sexto','IN6AM','PE6DM','JM','Computación','0007300770');
call sp_agregarPersona2(40416,'2020613','Pablo David','Realiquez Noriega','Sexto','IN6AM','PE6DM','JM','Computación','0007285989');
call sp_agregarPersona2(40417,'2022433','DIego Andres','Reyes Revolorio','Sexto','IN6AM','PE6DM','JM','Computación','0007266910');
call sp_agregarPersona2(40418,'2020318','José Julián','Rivas Alemán','Sexto','IN6AM','PE6DM','JM','Computación','0007994970');
call sp_agregarPersona2(40419,'2021170','Dilan André','Rodas Aldana','Sexto','IN6AM','PE6DM','JM','Computación','0008006688');
call sp_agregarPersona2(40420,'2023091','JEFFERSON ANIBAL','SICAN SEIJAS','Sexto','IN6AM','PE6DM','JM','Computación','0008043157');
call sp_agregarPersona2(40421,'2020289','Luis Eduardo','Vásquez Pérez','Sexto','IN6AM','PE6DM','JM','Computación','0008057683');
call sp_agregarPersona2(40422,'2020246','Andres Gilberto','Artiga Pérez','Sexto','IN6BM','PE6BM','JM','Computación','0008061485');
call sp_agregarPersona2(40423,'2020527','Diego Adolfo','Bercian Pérez','Sexto','IN6BM','PE6BM','JM','Computación','0008069470');
call sp_agregarPersona2(40424,'2023060','MARCO JOSE','BOLAÑOS MARTINEZ','Sexto','IN6BM','PE6BM','JM','Computación','0008056170');
call sp_agregarPersona2(40425,'2020429','Luis Rafael','Cordova Ruiz','Sexto','IN6BM','PE6BM','JM','Computación','0008059106');
call sp_agregarPersona2(40426,'2019272','Carlos Eduardo','Escobar García','Sexto','IN6BM','PE6BM','JM','Computación','0007995484');
call sp_agregarPersona2(40427,'2020229','Anthony Josué','Escobar Ponce','Sexto','IN6BM','PE6BM','JM','Computación','0007274922');
call sp_agregarPersona2(40428,'2023015','José David','Figueroa Muñoz','Sexto','IN6BM','PE6BM','JM','Computación','0007987907');
call sp_agregarPersona2(40429,'2023532','Diego Fernando','García Gálvez','Sexto','IN6BM','PE6BM','JM','Computación','0007989705');
call sp_agregarPersona2(40430,'2020459','Javier Eduardo','Herrera Pérez','Sexto','IN6BM','PE6BM','JM','Computación','0008035596');
call sp_agregarPersona2(40431,'2020385','José Luis Emanuel','López Laynes','Sexto','IN6BM','PE6BM','JM','Computación','0008019880');
call sp_agregarPersona2(40432,'2021572','Emilio José','Lux Zapeta','Sexto','IN6BM','PE6BM','JM','Computación','0005722518');
call sp_agregarPersona2(40433,'2021365','Carlos André','Morales Coy','Sexto','IN6BM','PE6DM','JM','Computación','0005494564');
call sp_agregarPersona2(40434,'2020045','Ramiro Donován','Morales López','Sexto','IN6BM','PE6DM','JM','Computación','0005499137');
call sp_agregarPersona2(40435,'2020493','Samuel Alexander','Perez Cap','Sexto','IN6BM','PE6DM','JM','Computación','0005510405');
call sp_agregarPersona2(40436,'2023013','Joshep Moises','Ramirez Gaitan','Sexto','IN6BM','PE6DM','JM','Computación','0005553466');
call sp_agregarPersona2(40437,'2020096','Julio Ricardo','Ramos Mencos','Sexto','IN6BM','PE6DM','JM','Computación','0005498405');
call sp_agregarPersona2(40438,'2020522','Danny Alfredo','Rodríguez Martínez','Sexto','IN6BM','PE6DM','JM','Computación','0005500458');
call sp_agregarPersona2(40439,'2023010','Daniel Eduardo','Sacol Cojón','Sexto','IN6BM','PE6DM','JM','Computación','0005500621');
call sp_agregarPersona2(40440,'2021518','Diego andree','Santandrea morales','Sexto','IN6BM','PE6DM','JM','Computación','0005508674');
call sp_agregarPersona2(40441,'2023011','Erick Jahir','Socop Colindres','Sexto','IN6BM','PE6DM','JM','Computación','0005569266');
call sp_agregarPersona2(40442,'2023014','Brayan Victorino','Toyom Garcia','Sexto','IN6BM','PE6DM','JM','Computación','0005553460');
call sp_agregarPersona2(40443,'2020247','Devyn Orlando','Tubac Gómez','Sexto','IN6BM','PE6DM','JM','Computación','0005498406');
call sp_agregarPersona2(40444,'2023017','Angel Javier','Tum González','Sexto','IN6BM','PE6DM','JM','Computación','0005553455');
call sp_agregarPersona2(40445,'2023313','Daniel Andrés','Tuy Tuchez','Sexto','IN6BM','PE6BM','JM','Computación','0005553761');
call sp_agregarPersona2(40446,'2023020','Ludwin Omar','Xocoy Miranda','Sexto','IN6BM','PE6DM','JM','Computación','0005569330');
call sp_agregarPersona2(40447,'2020194','Ian Karel','Alfaro Santos','Sexto','IN6CM','PE6EM','JM','Computación','0008069439');
call sp_agregarPersona2(40448,'2020374','Esteban Adolfo','Cano González','Sexto','IN6CM','PE6EM','JM','Computación','0008059916');
call sp_agregarPersona2(40449,'2020313','Giovanni Emmanuel','Carrera Garrido','Sexto','IN6CM','PE6EM','JM','Computación','0007985725');
call sp_agregarPersona2(40450,'2020359','José Pablo','Cipriano Aceytuno','Sexto','IN6CM','PE6EM','JM','Computación','0007280198');
call sp_agregarPersona2(40451,'2023105','Jonathan David','Garcia Gutierrez','Sexto','IN6CM','PE6EM','JM','Computación','0007282560');
call sp_agregarPersona2(40452,'2023455','Kevin Daniel','Gutierrez Rodríguez','Sexto','IN6CM','PE6EM','JM','Computación','0007289657');
call sp_agregarPersona2(40453,'2020388','Christian André','Medrano Reyes','Sexto','IN6CM','PE6EM','JM','Computación','0007257519');
call sp_agregarPersona2(40454,'2020266','Luis Pedro','Mejia Bravo','Sexto','IN6CM','PE6EM','JM','Computación','0007313164');
call sp_agregarPersona2(40455,'2020332','Pablo Rodrigo','Menéndez Palma','Sexto','IN6CM','PE6EM','JM','Computación','0007296848');
call sp_agregarPersona2(40456,'2020131','Hayler Eithan Cole','Monroy Vargas','Sexto','IN6CM','PE6EM','JM','Computación','0007272642');
call sp_agregarPersona2(40457,'2023234','Diego Alexander','Monterroso Estrada','Sexto','IN6CM','PE6EM','JM','Computación','0007302312');
call sp_agregarPersona2(40458,'2020558','Jose Carlos','Morejón Osorio','Sexto','IN6CM','PE6EM','JM','Computación','0007287303');
call sp_agregarPersona2(40459,'2019392','Carlos Adalberto','Orozco Campos','Sexto','IN6CM','PE6EM','JM','Computación','0007290562');
call sp_agregarPersona2(40460,'2020544','Carlos Ernesto','Priego Aceytuno','Sexto','IN6CM','PE6EM','JM','Computación','0007258061');
call sp_agregarPersona2(40461,'2020339','José Alejandro','Arévalo Castillo','Sexto','DB6AM','PE6CM','JM','Dibujo Técnico','0008060170');
call sp_agregarPersona2(40462,'2023042','Jose Javier','Avendaño Castellón','Sexto','DB6AM','PE6CM','JM','Dibujo Técnico','0008073774');
call sp_agregarPersona2(40463,'2020353','Pedro Angel','Blas Valle','Sexto','DB6AM','PE6CM','JM','Dibujo Técnico','0008046740');
call sp_agregarPersona2(40464,'2020391','Anderson Denilson','Canel Sequen','Sexto','DB6AM','PE6CM','JM','Dibujo Técnico','0008074592');
call sp_agregarPersona2(40465,'2020294','Carlos Alexander','Chacón Sucuquí','Sexto','DB6AM','PE6CM','JM','Dibujo Técnico','0005720085');
call sp_agregarPersona2(40466,'2020397','Emilio','Contreras Motta','Sexto','DB6AM','PE6CM','JM','Dibujo Técnico','0008023918');
call sp_agregarPersona2(40467,'2020150','Juan Fernando','Estrada Diaz','Sexto','DB6AM','PE6CM','JM','Dibujo Técnico','0008007747');
call sp_agregarPersona2(40468,'2023126','Diego Andrés','Godínez Herrera','Sexto','DB6AM','PE6CM','JM','Dibujo Técnico','0008015679');
call sp_agregarPersona2(40469,'2020200','Pablo David','Gómez Gómez','Sexto','DB6AM','PE6CM','JM','Dibujo Técnico','0007252507');
call sp_agregarPersona2(40470,'2023047','Angel Adrian','González Aquino','Sexto','DB6AM','PE6CM','JM','Dibujo Técnico','0007265452');
call sp_agregarPersona2(40471,'2020540','Angel Sebastian','González Cabria','Sexto','DB6AM','PE6CM','JM','Dibujo Técnico','0007283811');
call sp_agregarPersona2(40472,'2023139','Josué Salvador','González Godinez','Sexto','DB6AM','PE6CM','JM','Dibujo Técnico','0007267876');
call sp_agregarPersona2(40473,'2023002','Gerardo Andrés','Hernandez Alegria','Sexto','DB6AM','PE6CM','JM','Dibujo Técnico','0007280229');
call sp_agregarPersona2(40474,'2019332','Juan Luis','Itzep Cúmez','Sexto','DB6AM','PE6CM','JM','Dibujo Técnico','0007262312');
call sp_agregarPersona2(40475,'2023108','Carlos Fernando','Juárez Rodríguez','Sexto','DB6AM','PE6CM','JM','Dibujo Técnico','0007309567');
call sp_agregarPersona2(40476,'2020124','Juan Carlos','López De León','Sexto','DB6AM','PE6CM','JM','Dibujo Técnico','0007303464');
call sp_agregarPersona2(40477,'2020174','Robinson Johandry','López Pineda','Sexto','DB6AM','PE6CM','JM','Dibujo Técnico','0005747425');
call sp_agregarPersona2(40478,'2023032','PABLO JOSUÉ','OCHOA PITIN','Sexto','DB6AM','PE6CM','JM','Dibujo Técnico','0007285371');
call sp_agregarPersona2(40479,'2023007','Mario Fernando','Pelicó Quel','Sexto','DB6AM','PE6CM','JM','Dibujo Técnico','0007269945');
call sp_agregarPersona2(40480,'2020181','Werner Pablo Alejandro','Rodríguez Ordoñez','Sexto','DB6AM','PE6CM','JM','Dibujo Técnico','0007281784');
call sp_agregarPersona2(40481,'2023041','Anderson Didier','Salazar Estevez','Sexto','DB6AM','PE6CM','JM','Dibujo Técnico','0007267069');
call sp_agregarPersona2(40482,'2023030','Mario Alfonso','Velasquez Navarro','Sexto','DB6AM','PE6EM','JM','Dibujo Técnico','0007307297');
call sp_agregarPersona2(40483,'2023039','Christian Daniel','Velasquez Ramos','Sexto','DB6AM','PE6EM','JM','Dibujo Técnico','0007312801');
call sp_agregarPersona2(40484,'2020435','Josue Alberto','Xiloj López','Sexto','DB6AM','PE6EM','JM','Dibujo Técnico','0007323396');
call sp_agregarPersona2(40485,'2020263','Ludwyn Steven','Ajsivinac Alonzo','Sexto','ET6AM','PE6EM','JM','Electrónica básica','0005689786');
call sp_agregarPersona2(40486,'2023149','Cristopher Rodrigo','Atz Lemus','Sexto','ET6AM','PE6CM','JM','Electrónica básica','0005692071');
call sp_agregarPersona2(40487,'2020265','Paulo André','Calito López','Sexto','ET6AM','PE6EM','JM','Electrónica básica','0005692076');
call sp_agregarPersona2(40488,'2023246','Ian Yeray Nikola','Castillo Román','Sexto','ET6AM','PE6CM','JM','Electrónica básica','0005734811');
call sp_agregarPersona2(40489,'2022465','José Adrián','Cifuentes León','Sexto','ET6AM','PE6CM','JM','Electrónica básica','0005734806');
call sp_agregarPersona2(40490,'2023232','Victor Armando','Culajay González','Sexto','ET6AM','PE6CM','JM','Electrónica básica','0005692065');
call sp_agregarPersona2(40491,'2023197','Edgar Santiago','Díaz Espinoza','Sexto','ET6AM','PE6CM','JM','Electrónica básica','0005692070');
call sp_agregarPersona2(40492,'2020249','Alvaro Angel Gabriel','Estrada Morales','Sexto','ET6AM','PE6CM','JM','Electrónica básica','0005692075');
call sp_agregarPersona2(40493,'2020564','Luis Francisco','Férnandez Raymundo','Sexto','ET6AM','PE6EM','JM','Electrónica básica','0005734810');
call sp_agregarPersona2(40494,'2023024','Allan Paul','Gonzalez Tzunun','Sexto','ET6AM','PE6EM','JM','Electrónica básica','0007266999');
call sp_agregarPersona2(40495,'2023069','Jose David','Guamuch Hernández','Sexto','ET6AM','PE6EM','JM','Electrónica básica','0007316913');
call sp_agregarPersona2(40496,'2023102','Henry Francisco','Leal Súchite','Sexto','ET6AM','PE6EM','JM','Electrónica básica','0007315052');
call sp_agregarPersona2(40497,'2020210','Paolo Eduardo','Orozco Argueta','Sexto','ET6AM','PE6EM','JM','Electrónica básica','0007283876');
call sp_agregarPersona2(40498,'2023113','Kevin Owen Roger','Pablo Lastor','Sexto','ET6AM','PE6EM','JM','Electrónica básica','0007269304');
call sp_agregarPersona2(40499,'2023194','Pablo Alfredo','Paiz Sosa','Sexto','ET6AM','PE6EM','JM','Electrónica básica','0008044058');
call sp_agregarPersona2(40500,'2020207','Josue Julian de Jesús','Robles Larios','Sexto','ET6AM','PE6EM','JM','Electrónica básica','0008006780');
call sp_agregarPersona2(40501,'2023134','Josué David','Santos Ramírez','Sexto','ET6AM','PE6EM','JM','Electrónica básica','0008060471');
call sp_agregarPersona2(40502,'2023322','Howard Adolfo','Say Rodríguez','Sexto','ET6AM','PE6EM','JM','Electrónica básica','0008044776');
call sp_agregarPersona2(40503,'2020175','Fabián Andree','Sinay Canel','Sexto','ET6AM','PE6EM','JM','Electrónica básica','0008038637');
call sp_agregarPersona2(40504,'2021486','José André','Torres Alvarado','Sexto','ET6AM','PE6EM','JM','Electrónica básica','0008049457');
call sp_agregarPersona2(40505,'2023173','José Fernando','Guillén Rodríguez','Sexto','EC6AM','PE6BM','JM','Electrónica básica','0007260294');
call sp_agregarPersona2(40506,'2023235','Bryan Enrique','López Pérez','Sexto','EC6AM','PE6BM','JM','Electrónica básica','0007248865');
call sp_agregarPersona2(40507,'2023208','José David','Marroquín Núñez','Sexto','EC6AM','PE6BM','JM','Electrónica básica','0007252977');
call sp_agregarPersona2(40508,'2020330','Eduardo Sebastian','Orozco Colop','Sexto','EC6AM','PE6BM','JM','Electrónica básica','0007248176');
call sp_agregarPersona2(40509,'2023219','Samuel Esteban','Picón Choc','Sexto','EC6AM','PE6BM','JM','Electrónica básica','0007247975');
call sp_agregarPersona2(40510,'2023100','Ricardo Andres','Rodríguez de León','Sexto','EC6AM','PE6BM','JM','Electrónica básica','0007328144');
call sp_agregarPersona2(40511,'2023283','Santiago Daniel','Yax Tiu','Sexto','EC6AM','PE6BM','JM','Electrónica básica','0005689789');
call sp_agregarPersona2(40512,'2023085','Andy Denilson','Ajpop Batz','Sexto','EL6AM','PE6AM','JM','Electricidad Industrial','0005685459');
call sp_agregarPersona2(40513,'2023145','Jeferson Imanol','Caal Anona','Sexto','EL6AM','PE6AM','JM','Electricidad Industrial','0005705044');
call sp_agregarPersona2(40514,'2023340','Oscar Anderson Ricardo','Chile Cuyan','Sexto','EL6AM','PE6AM','JM','Electricidad Industrial','0005676173');
call sp_agregarPersona2(40515,'2021574','Rodrigo Alexander','Escalante de Paz','Sexto','EL6AM','PE6AM','JM','Electricidad Industrial','0005676168');
call sp_agregarPersona2(40516,'2020253','Rodrigo Jose','Guzmán Milian','Sexto','EL6AM','PE6AM','JM','Electricidad Industrial','0005676163');
call sp_agregarPersona2(40517,'2023368','ABNER DANIEL','IXCOT HERRARTE','Sexto','EL6AM','PE6AM','JM','Electricidad Industrial','0005704558');
call sp_agregarPersona2(40518,'2023016','Ismael Abisai','Martínez Rivera','Sexto','EL6AM','PE6AM','JM','Electricidad Industrial','0005701434');
call sp_agregarPersona2(40519,'2020297','Angel Daniel','Moreira Pérez','Sexto','EL6AM','PE6AM','JM','Electricidad Industrial','0005701429');
call sp_agregarPersona2(40520,'2020358','Noé Alejandro','Osorio Ortíz','Sexto','EL6AM','PE6AM','JM','Electricidad Industrial','0005704893');
call sp_agregarPersona2(40521,'2023125','Pablo Javier','Puluc Toyom','Sexto','EL6AM','PE6AM','JM','Electricidad Industrial','0005704897');
call sp_agregarPersona2(40522,'2023287','Angel Emilio','Ramos Aguilar','Sexto','EL6AM','PE6AM','JM','Electricidad Industrial','0005664000');
call sp_agregarPersona2(40523,'2023452','Ervin Sebastian','Ruiz Carrera','Sexto','EL6AM','PE6AM','JM','Electricidad Industrial','0005719983');
call sp_agregarPersona2(40524,'2023051','Carlos Alejandro José','Subuyuj Subuyuj','Sexto','EL6AM','PE6AM','JM','Electricidad Industrial','0005719993');
call sp_agregarPersona2(40525,'2023171','Jorge Mario','Yoo Alvarado','Sexto','EL6AM','PE6AM','JM','Electricidad Industrial','0005720479');
call sp_agregarPersona2(40526,'2023212','CRISTIAN HORACIO','ANONA CHUNCHUN','Sexto','EL6AM','PE6AM','JM','Electricidad Industrial','0007317463');
call sp_agregarPersona2(40527,'2023389','Erickson Uriel','Benito García','Sexto','EL6AM','PE6AM','JM','Electricidad Industrial','0007304633');
call sp_agregarPersona2(40528,'2023331','Jormar Javier','Felipe Calel','Sexto','EL6AM','PE6AM','JM','Electricidad Industrial','0004758262');
call sp_agregarPersona2(40529,'2023316','Oscar Juan David','Lopez Osorio','Sexto','EL6AM','PE6AM','JM','Electricidad Industrial','0004780330');
call sp_agregarPersona2(40530,'2023290','Daniel Adrián','Rodríguez Reynosa','Sexto','EL6AM','PE6AM','JM','Electricidad Industrial','0005687220');
call sp_agregarPersona2(40531,'2023414','Brandon Javier','Santos Jerez','Sexto','EL6AM','PE6AM','JM','Electricidad Industrial','0005687211');
call sp_agregarPersona2(40532,'2023264','Dennis Alexander','Tuy Zorrillo','Sexto','EL6AM','PE6AM','JM','Electricidad Industrial','0005678083');
call sp_agregarPersona2(40533,'2022431','Andy Anderson','Vicente Pirir','Sexto','EL6AM','PE6AM','JM','Electricidad Industrial','0005678084');
call sp_agregarPersona2(40534,'2023158','Pedro Sergio Javier','Bautista Matheu','Sexto','IN6AV','PE6BV','JV','Computación','0007253354');
call sp_agregarPersona2(40535,'2023107','Joel Alejandro','Chávez Pérez','Sexto','IN6AV','PE6BV','JV','Computación','0007264020');
call sp_agregarPersona2(40536,'2023223','César Alejandro','Colorado Jacobo','Sexto','IN6AV','PE6BV','JV','Computación','0007304855');
call sp_agregarPersona2(40537,'2023048','NERY JAVIER','DE LA CRUZ HUINIL','Sexto','IN6AV','PE6BV','JV','Computación','0005558380');
call sp_agregarPersona2(40538,'2023195','José Francisco','González Ordoñez','Sexto','IN6AV','PE6BV','JV','Computación','0005560566');
call sp_agregarPersona2(40539,'2023053','José Manuel','Gramajo Pineda','Sexto','IN6AV','PE6BV','JV','Computación','0005560571');
call sp_agregarPersona2(40540,'2023066','Rene Alfredo','López Castellanos','Sexto','IN6AV','PE6BV','JV','Computación','0005558444');
call sp_agregarPersona2(40541,'2023076','Diego Antonio','Marroquin Franco','Sexto','IN6AV','PE6BV','JV','Computación','0007253738');
call sp_agregarPersona2(40542,'2023026','Jeancarlo Josue','Marroquín Martínez','Sexto','IN6AV','PE6BV','JV','Computación','0007270552');
call sp_agregarPersona2(40543,'2023205','Ricardo Alberto','Martín Quiché','Sexto','IN6AV','PE6BV','JV','Computación','0007289745');
call sp_agregarPersona2(40544,'2023045','Diego Alexander','Medina Urizar','Sexto','IN6AV','PE6BV','JV','Computación','0007304053');
call sp_agregarPersona2(40545,'2023159','Jared Sebastián','Morataya Hernández','Sexto','IN6AV','PE6BV','JV','Computación','0007326837');
call sp_agregarPersona2(40546,'2023046','Marcos Joel','Pamal Marroquin','Sexto','IN6AV','PE6BV','JV','Computación','0007294184');
call sp_agregarPersona2(40547,'2023025','José David','Retana Retana','Sexto','IN6AV','PE6BV','JV','Computación','0007282951');
call sp_agregarPersona2(40548,'2023022','Kenny Alexander Luciano','Terraza Castro','Sexto','IN6AV','PE6BV','JV','Computación','0007326565');
call sp_agregarPersona2(40549,'2023095','Denis Alfredo','Vela Velasquez','Sexto','IN6AV','PE6BV','JV','Computación','0007311463');
call sp_agregarPersona2(40550,'2023124','Sebastián Eduardo','Veliz pinto','Sexto','IN6AV','PE6BV','JV','Computación','0007296251');
call sp_agregarPersona2(40551,'2023428','Abner Alberto','Albizurez Guzmán','Sexto','MA6BV','PE6BV','JV','Mecánica Automotriz','0005747430');
call sp_agregarPersona2(40552,'2023447','Jonathan Daniel','Barrera Sutuj','Sexto','MA6BV','PE6BV','JV','Mecánica Automotriz','0005734708');
call sp_agregarPersona2(40553,'2023473','Kevin Rúben','Chiquitó Coló','Sexto','MA6BV','PE6BV','JV','Mecánica Automotriz','0008024540');
call sp_agregarPersona2(40554,'2023200','Angel Daniel','Contreras Melgar','Sexto','MA6BV','PE6BV','JV','Mecánica Automotriz','0007250119');
call sp_agregarPersona2(40555,'2023249','Angel Andre','Esqueque Paz','Sexto','MA6BV','PE6BV','JV','Mecánica Automotriz','0007298366');
call sp_agregarPersona2(40556,'2020599','Joshua Abdallah','Fuentes Pineda','Sexto','MA6BV','PE6BV','JV','Mecánica Automotriz','0007313702');
call sp_agregarPersona2(40557,'2023207','Angel Fernando','Gonzalez de León','Sexto','MA6BV','PE6BV','JV','Mecánica Automotriz','0007270414');
call sp_agregarPersona2(40558,'2023285','Ángel Ricardo','Jiatz Zelada','Sexto','MA6BV','PE6BV','JV','Mecánica Automotriz','0007250022');
call sp_agregarPersona2(40559,'2023420','Guily Noé Oswaldo','Mancilla Chacón','Sexto','MA6BV','PE6BV','JV','Mecánica Automotriz','0007298380');
call sp_agregarPersona2(40560,'2023427','Josué Guillermo','Mansilla Alvarez','Sexto','MA6BV','PE6BV','JV','Mecánica Automotriz','0005755940');
call sp_agregarPersona2(40561,'2023388','Damian Elizandro','Pedro Gutierrez','Sexto','MA6BV','PE6BV','JV','Mecánica Automotriz','0005755945');
call sp_agregarPersona2(40562,'2023288','José Jeyk','Pinzón Balán','Sexto','MA6BV','PE6BV','JV','Mecánica Automotriz','0005744956');
call sp_agregarPersona2(40563,'2023213','Harri Anthony','Suruy Yol','Sexto','MA6BV','PE6BV','JV','Mecánica Automotriz','0007993866');
call sp_agregarPersona2(40564,'2023311','Carlos Enrique','Torres Abal','Sexto','MA6BV','PE6BV','JV','Mecánica Automotriz','0007998592');
call sp_agregarPersona2(40565,'2023286','Angel Andre','Alonzo Maldonado','Sexto','DB6AV','PE6DV','JV','Dibujo Técnico','0007314135');
call sp_agregarPersona2(40566,'2023250','Juan Andrés','Barán Xinico','Sexto','DB6AV','PE6DV','JV','Dibujo Técnico','0007313818');
call sp_agregarPersona2(40567,'2023260','César Fernando De Jesús','Cano Canel','Sexto','DB6AV','PE6DV','JV','Dibujo Técnico','0007321004');
call sp_agregarPersona2(40568,'2023304','Juan Pablo','Cano Peláez','Sexto','DB6AV','PE6DV','JV','Dibujo Técnico','0007304436');
call sp_agregarPersona2(40569,'2023204','Carlos Fernando','Carrasco Yac','Sexto','DB6AV','PE6DV','JV','Dibujo Técnico','0007330343');
call sp_agregarPersona2(40570,'2020147','Cristian Andrés','Cruz Tiú','Sexto','DB6AV','PE6DV','JV','Dibujo Técnico','0007326881');
call sp_agregarPersona2(40571,'2023276','Dustin Bernabeu','Del Cid Diéguez','Sexto','DB6AV','PE6DV','JV','Dibujo Técnico','0007286164');
call sp_agregarPersona2(40572,'2020472','Cedrick Khaleb Alessander','Flores Marroquin','Sexto','DB6AV','PE6DV','JV','Dibujo Técnico','0007254328');
call sp_agregarPersona2(40573,'2023157','Jorge Andres','González Betancourt','Sexto','DB6AV','PE6DV','JV','Dibujo Técnico','0007303279');
call sp_agregarPersona2(40574,'2023254','Gary Henry Yovany','Medrano Hernadez','Sexto','DB6AV','PE6DV','JV','Dibujo Técnico','0007296163');
call sp_agregarPersona2(40575,'2023404','Brayan Orlando','Monrroy Gil','Sexto','DB6AV','PE6DV','JV','Dibujo Técnico','0007300186');
call sp_agregarPersona2(40576,'2023136','Jeffry Alexander','Monzón Tezen','Sexto','DB6AV','PE6DV','JV','Dibujo Técnico','0007249817');
call sp_agregarPersona2(40577,'2023419','Aaron','Peñalonzo rodriguez','Sexto','DB6AV','PE6DV','JV','Dibujo Técnico','0007255351');
call sp_agregarPersona2(40578,'2020259','Diego Ernesto','Pérez Barreda','Sexto','DB6AV','PE6DV','JV','Dibujo Técnico','0007263422');
call sp_agregarPersona2(40579,'2023271','Alan Eliú','Rafael Serrano','Sexto','DB6AV','PE6DV','JV','Dibujo Técnico','0007276882');
call sp_agregarPersona2(40580,'2023280','Ederson Esneyder','Ramírez Martínez','Sexto','DB6AV','PE6DV','JV','Dibujo Técnico','0007262337');
call sp_agregarPersona2(40581,'2023459','Mario Josué','Camposeco Álvarez','Sexto','EC6AV','PE6CV','JV','Electrónica básica','0007295383');
call sp_agregarPersona2(40582,'2023556','José Filiberto','Hernández De Paz','Sexto','EC6AV','PE6CV','JV','Electrónica básica','0007330191');
call sp_agregarPersona2(40583,'2023088','José Alejandro','Perez Valencia','Sexto','EC6AV','PE6CV','JV','Electrónica básica','0007318765');
call sp_agregarPersona2(40584,'2023393','Jeremy Alexander','Solares Álvarez','Sexto','EC6AV','PE6CV','JV','Electrónica básica','0007323999');
call sp_agregarPersona2(40585,'2023244','Bryan Isaac','Alvarez Aldana','Sexto','IN6BV','PE6AV','JV','Computación','0007291542');
call sp_agregarPersona2(40586,'2023238','Paulo Giovanni','Alvarez Ramos','Sexto','IN6BV','PE6AV','JV','Computación','0007305832');
call sp_agregarPersona2(40587,'2023128','Javier Alejandro','Apen Solis','Sexto','IN6BV','PE6AV','JV','Computación','0005558445');
call sp_agregarPersona2(40588,'2023179','JOSÉ GABRIEL','CONTRERAS SÁNCHEZ','Sexto','IN6BV','PE6AV','JV','Computación','0007280947');
call sp_agregarPersona2(40589,'2023324','Josué David','Garcia Méndez','Sexto','IN6BV','PE6AV','JV','Computación','0007316027');
call sp_agregarPersona2(40590,'2023302','Crhistopher Alexander','Gómez Rojas','Sexto','IN6BV','PE6AV','JV','Computación','0007257057');
call sp_agregarPersona2(40591,'2023176','Fredy Lizandro','Hernández Gómez','Sexto','IN6BV','PE6AV','JV','Computación','0007275913');
call sp_agregarPersona2(40592,'2023308','Cristian Alfredo','Luna Sisimit','Sexto','IN6BV','PE6DV','JV','Computación','0007296686');
call sp_agregarPersona2(40593,'2023242','David Emanuel','Morente González','Sexto','IN6BV','PE6DV','JV','Computación','0005682600');
call sp_agregarPersona2(40594,'2023279','Randy Omar','Oscal Cabrera','Sexto','IN6BV','PE6DV','JV','Computación','0005704193');
call sp_agregarPersona2(40595,'2023278','Harol Aníbal','Rodríguez Con','Sexto','IN6BV','PE6DV','JV','Computación','0007272937');
call sp_agregarPersona2(40596,'2023292','Mario Andreé','Rodríguez Zamboni','Sexto','IN6BV','PE6DV','JV','Computación','0007269111');
call sp_agregarPersona2(40597,'2023147','Steven Adrián','Soto Morataya','Sexto','IN6BV','PE6DV','JV','Computación','0007253545');
call sp_agregarPersona2(40598,'2023496','Andrill José Rolando','Aguilar López','Sexto','IN6CV','PE6AV','JV','Computación','0007270056');
call sp_agregarPersona2(40599,'2023555','Martin Santiago','Contreras Ramírez','Sexto','IN6CV','PE6AV','JV','Computación','0007285217');
call sp_agregarPersona2(40600,'2023454','Luis Eduardo','De León Barrientos','Sexto','IN6CV','PE6AV','JV','Computación','0007261631');
call sp_agregarPersona2(40601,'2023417','Herbert Joaquin','Figueroa Alvarez','Sexto','IN6CV','PE6AV','JV','Computación','0007275872');
call sp_agregarPersona2(40602,'2023376','Aldair Alejandro','González Araujo','Sexto','IN6CV','PE6AV','JV','Computación','0007318473');
call sp_agregarPersona2(40603,'2023475','Lisandro','Jiménez Vásquez','Sexto','IN6CV','PE6AV','JV','Computación','0007329998');
call sp_agregarPersona2(40604,'2023480','Cristian Estuardo','Lima Ruano','Sexto','IN6CV','PE6AV','JV','Computación','0007990876');
call sp_agregarPersona2(40605,'2020379','Werner Wilfrido','Paredes Panigua','Sexto','IN6CV','PE6AV','JV','Computación','0008000768');
call sp_agregarPersona2(40606,'2023478','Jorge Andrés','Peralta Martínez','Sexto','IN6CV','PE6AV','JV','Computación','0008002935');
call sp_agregarPersona2(40607,'2023396','Luis Angel','Pichiyá Sisimit','Sexto','IN6CV','PE6AV','JV','Computación','0007302566');
call sp_agregarPersona2(40608,'2023395','brandon thomas','pu quiñonez','Sexto','IN6CV','PE6AV','JV','Computación','0007268713');
call sp_agregarPersona2(40609,'2023500','Cristian René','Rosas Hernández','Sexto','IN6CV','PE6AV','JV','Computación','0007333797');
call sp_agregarPersona2(40610,'2023386','Manuel Alejandro','Tejeda Guerra','Sexto','IN6CV','PE6AV','JV','Computación','0007251283');
call sp_agregarPersona2(40611,'2023589','Josue Javier','Yax Ixcoy','Sexto','IN6CV','PE6AV','JV','Computación','0007309942');
call sp_agregarPersona2(40612,'2020594','Pablo Antonio','Argueta Villatoro','Sexto','MA6AV','PE6CV','JV','Mecánica Automotriz','0005728293');
call sp_agregarPersona2(40613,'2020556','Henry Francisco Samuel','Chinchilla Méndez','Sexto','MA6AV','PE6CV','JV','Mecánica Automotriz','0005728288');
call sp_agregarPersona2(40614,'2020360','Ian Andrés','Hernández Farfán','Sexto','MA6AV','PE6CV','JV','Mecánica Automotriz','0005731532');
call sp_agregarPersona2(40615,'2023231','Jorge Xavier','Maltez Rodas','Sexto','MA6AV','PE6CV','JV','Mecánica Automotriz','0005731537');
call sp_agregarPersona2(40616,'2023327','Francisco José Alejandro','Martínez Espinoza','Sexto','MA6AV','PE6CV','JV','Mecánica Automotriz','0005734790');
call sp_agregarPersona2(40617,'2020350','Daniel Eduardo','Oliva de León','Sexto','MA6AV','PE6CV','JV','Mecánica Automotriz','0005700781');
call sp_agregarPersona2(40618,'2023266','Cristian Roberto','Peralta Santiago','Sexto','MA6AV','PE6CV','JV','Mecánica Automotriz','0005700393');
call sp_agregarPersona2(40619,'2023034','Carlos Emanuel','Soto Rios','Sexto','MA6AV','PE6CV','JV','Mecánica Automotriz','0005700786');
call sp_agregarPersona2(40620,'2021390','Javier Sebastian','Valdes Mayor','Sexto','MA6AV','PE6CV','JV','Mecánica Automotriz','0005729926');
call sp_agregarPersona2(40621,'2023374','Ludwin Alejandro','Veliz Esteban','Sexto','MA6AV','PE6CV','JV','Mecánica Automotriz','0005747215');
call sp_agregarPersona2(40622,'2022503','Luis Fernando','Leiva Quezada','Sexto','ET6AV','PE6CV','JV','Electrónica básica','0007253969');
call sp_agregarPersona2(40623,'2023442','Damasco','Oxcal Vásquez','Sexto','ET6AV','PE6CV','JV','Electrónica básica','0005558379');
call sp_agregarPersona2(40624,'2022019','Victor Adrian','Pantuj Lobos','Sexto','ET6AV','PE6CV','JV','Electrónica básica','0005560859');
call sp_agregarPersona2(40625,'2023557','Oscar Mario','Portillo Mus','Sexto','ET6AV','PE6CV','JV','Electrónica básica','0005560854');
call sp_agregarPersona2(40626,'2023333','Steven Josué','Sicaján Pacheco','Sexto','ET6AV','PE6CV','JV','Electrónica básica','0007268304');
call sp_agregarPersona2(40627,'2023216','Cristopher Josué','Tzún Acabal','Sexto','ET6AV','PE6CV','JV','Electrónica básica','0007296051');
call sp_agregarPersona2(40628,'2023168','Manfredo Guillermo','Vasquez Gomez','Sexto','ET6AV','PE6CV','JV','Electrónica básica','0007313984');
call sp_agregarPersona2(40629,'2024314','Jose Francisco','Rodriguez Rodriguez','Segundo','BA2EM','N/A','JM','Educación Básica','0005505231');
call sp_agregarPersona2(40630,'2024253','Sanders Leonel','Martinez Figueroa','Segundo','BA2AM','N/A','JM','Educación Básica','0001866989');
call sp_agregarPersona2(40631,'2024543','Jose Daniel','Lopez Esturbán','Segundo','BA2AM','N/A','JM','Educación Básica','0001833217');
call sp_agregarPersona2(40632,'2024282','Jostyn Alexis','García Méndez','Segundo','BA2AM','N/A','JM','Educación Básica','0007698787');
call sp_agregarPersona2(40633,'2024360','Oscar Rodrigo','Díaz Azurdia','Segundo','BA2CM','N/A','JM','Educación Básica','0005506170');
call sp_agregarPersona2(40634,'2024371','Obed Alessandro','Díaz Donis','Segundo','BA2BM','N/A','JM','Educación Básica','0007429369');
call sp_agregarPersona2(40635,'2024236','Santiago Alberto','Gualín Reyes','Segundo','BA2BM','N/A','JM','Educación Básica','0007411928');
call sp_agregarPersona2(40636,'2024304','Santiago','Rivera Guerra','Segundo','BA2BM','N/A','JM','Educación Básica','0006815823');
call sp_agregarPersona2(40637,'2024163','Josué Alejandro','Navas Torres','Segundo','BA2DM','N/A','JM','Educación Básica','0091075178');
call sp_agregarPersona2(40638,'2022332','Harold Josellito David','Pantó Alva','Tercero','BA3DM','N/A','JM','Educación Básica','0091084690');
call sp_agregarPersona2(40639,'2024499','Victor Gabriel','Sotoy Hernández','Tercero','BA3DM','N/A','JM','Educación Básica','0005553447');
call sp_agregarPersona2(40640,'2024516','Joel Andre','Diaz Azurdia','Tercero','BA3CM','N/A','JM','Educación Básica','0006606229');
call sp_agregarPersona2(40641,'2024486','Derek Alexander','Gonzalez Silvestre','Tercero','BA3CM','N/A','JM','Educación Básica','0006623993');
call sp_agregarPersona2(40642,'2023353','Aido Carlos Mariano','Rivas Morales','Tercero','BA3CM','N/A','JM','Educación Básica','0006964584');
call sp_agregarPersona2(40643,'2023434','SERGIO ESTEBAN','CANO ALONZO','Tercero','BA3AM','N/A','JM','Educación Básica','0002752440');
call sp_agregarPersona2(40644,'2022149','Efren Adelso','Orellana Herrarte','Cuarto ','IN4BM','PE4DM','JM','Computación','0005500689');
call sp_agregarPersona2(40645,'2024547','Diego Julian','Aguilar Taracena','Quinto ','MA5AM','PE5AM','JM','Mecánica Automotriz','0007294263');
call sp_agregarPersona2(40646,'2024039','Marcos Josué','Alvarez Santos','Quinto ','DB5AM','PE5CM','JM','Dibujo Técnico','0007250462');
call sp_agregarPersona2(40647,'2024079','Edvin Manuel','Vega Romero','Quinto ','EB5BM','PE5AM','JM','Electrónica básica','0007308597');
call sp_agregarPersona2(40648,'2021197','Santiago','Morales Salazar','Quinto ','EB5BM','PE5DM','JM','Electrónica básica','0007256785');
call sp_agregarPersona2(40649,'2021555','Oscar Daniel','Sacalxot Méndez','Quinto ','EB5AM','PE5BM','JM','Electrónica básica','0007253030');
call sp_agregarPersona2(40650,'2021278','Edwin Samuel','Ordoñez Gudiel','Quinto ','EB5AM','PE5BM','JM','Electrónica básica','0007331885');
call sp_agregarPersona2(40651,'2024109','Brayan Mauricio','Zet De León','Quinto ','MA5BV','PE5DV','JV','Mecánica Automotriz','0007281058');
call sp_agregarPersona2(40652,'2024259','Gabriel Eduardo','Uz Dubon','Quinto ','MA5BV','PE5DV','JV','Mecánica Automotriz','0007267216');
call sp_agregarPersona2(40653,'2024257','Hector Eliseo','Ujpan Martin','Quinto ','MA5BV','PE5DV','JV','Mecánica Automotriz','0007254920');
call sp_agregarPersona2(40654,'2024182','José Andres','Guacamaya Pocón','Quinto ','MA5BV','PE5DV','JV','Mecánica Automotriz','0008068678');
call sp_agregarPersona2(40655,'2024092','Ricardo Fabian','Pérez Santos','Quinto ','MA5BM','PE5CM','JM','Mecánica Automotriz','0007327819');
call sp_agregarPersona2(40656,'2024022','Cristian Enrique','Santos Martínez','Quinto ','IN5BM','PE5EM','JM','Computación','0008008588');
call sp_agregarPersona2(40657,'2024027','Anderson Josué','Catú Yos','Quinto ','EL5AM','PE5BM','JM','Electricidad Industrial','0007246511');
call sp_agregarPersona2(40658,'2021129','Manuel Antonio','Garcia Juárez','Quinto ','IN5AM','PE5DM','JM','Computación','0007317428');
call sp_agregarPersona2(40659,'2024435','Angel Geovanny','Reyes Vinasco','Quinto ','IN5CV','PE5CV','JV','Computación','0007267027');
call sp_agregarPersona2(40660,'2024237','Fred Alexandre','Pacheco García','Quinto ','IN5AV','PE5AV','JV','Computación','0007334549');
call sp_agregarPersona2(40661,'2024247','Rigoberto','Godinez Fajardo','Quinto ','IN5AV','PE5AV','JV','Computación','0007313605');
call sp_agregarPersona2(40662,'2023345','Luis Carlos','Gutiérrez Chuy','Sexto','DB6AV','PE6DV','JV','Dibujo Técnico','0007273034');
call sp_agregarPersona2(40663,'2023141','José Daniel','Díaz López','Sexto','DB6AV','PE6DV','JV','Dibujo Técnico','0007270631');
call sp_agregarPersona2(40664,'2023485','Robbin Williams','Sisimit Plato','Sexto','IN6CV','PE6AV','JV','Computación','0007258950');
call sp_agregarPersona2(40665,'2023378','José Alfredo','Ajcú González','Sexto','IN6CV','PE6AV','JV','Computación','0007290034');
call sp_agregarPersona2(40666,'2023338','Carlos Josué Samuel','Santos Martínez','Sexto','ET6AV','PE6CV','JV','Electrónica básica','0007268007');
call sp_agregarPersona2(40667,'2020351','Gabriel José María','Ordoñez Rubí','Sexto','ET6AV','PE6CV','JV','Electrónica básica','0005558384');
call sp_agregarPersona2(40668,'2023518','Luis Alejandro','Cuxun Hernández','Sexto','IN6CM','PE6EM','JM','Computación','0007317013');
call sp_agregarPersona2(40669,'2020282','Gerardo Alfonso','Contreras Estrada','Sexto','IN6CM','PE6EM','JM','Computación','0007283068');
call sp_agregarPersona2(40670,'2020619','Fernando David','Choc Baltazar','Sexto','IN6CM','PE6EM','JM','Computación','0007985849');
call sp_agregarPersona2(40671,'2023198','Pablo Daniel','Castillo Ramírez','Sexto','IN6CM','PE6EM','JM','Computación','0008006834');
call sp_agregarPersona2(40672,'2020398','Adrián Alessandro','Arbizú del Cid','Sexto','IN6CM','PE6EM','JM','Computación','0008054127');
call sp_agregarPersona2(40673,'2023019','Ignacio Sebastian','Hernandez Payes','Sexto','IN6AV','PE6BV','JV','Computación','0005560577');
call sp_agregarPersona2(40674,'2023106','Andre Sebastian','Figueroa Barrios','Sexto','IN6AV','PE6BV','JV','Computación','0005747429');
call sp_agregarPersona2(40675,'2023451','Derick Steph','Rafael Avila','Tercero','BA3EM','N/A','JM','Educación Básica','0007289390');
call sp_agregarPersona2(40676,'2023568','Christopher Daniel','Orizabal Keydel','Tercero','BA3EM','N/A','JM','Educación Básica','0007263420');
call sp_agregarPersona2(40677,'2024545','Marlon David','Soto de León','Tercero','BA3DM','N/A','JM','Educación Básica','0007279634');
call sp_agregarPersona2(40678,'2023243','José Juan Pablo','Lol Méndez','Tercero','BA3AM','N/A','JM','Educación Básica','0007260105');
call sp_agregarPersona2(40679,'2024154','Angel Mateo','Santiagos Alvarez','Segundo','BA2DM','N/A','JM','Educación Básica','0007277164');
call sp_agregarPersona2(40680,'2024456','Josue Gabriel','Barrera garcía','Segundo','BA2BM','N/A','JM','Educación Básica','0007292884');
call sp_agregarPersona2(40681,'2025536','Marco Pablo Gamaliel','Morales Cano','Primero','BA1GM','N/A','JM','Educación Básica','0007269352');
call sp_agregarPersona2(40682,'2025390','Oswaldo Lemuel','Say Urias','Primero','BA1EM','N/A','JM','Educación Básica','0007251704');
call sp_agregarPersona2(40683,'2025431','Ronnie Alexander','Toja Monzon','Primero','BA1AM','N/A','JM','Educación Básica','0007321842');
call sp_agregarPersona2(40684,'2025380','Angel Antonio','Salguero Camey','Primero','BA1AM','N/A','JM','Educación Básica','0007332875');
call sp_agregarPersona2(40685,'2025004','Angel Santiago','Méndez Mejia','Primero','BA1AM','N/A','JM','Educación Básica','0008026769');
call sp_agregarPersona2(40686,'2025564','Cristhofer jack','Barrera garcia','Primero','BA1AM','N/A','JM','Educación Básica','0008013123');
call sp_agregarPersona2(40687,'2025048','Roberto Angel','Prado Sian','Cuarto','MB4AV','PE4CV','JV','Mecánica Automotriz','0007289286');
call sp_agregarPersona2(40688,'2023248','Israel Alexánder','Herrera Xón','Quinto ','MA5BV','PE5DV','JV','Mecánica Automotriz','0007274882');
call sp_agregarPersona2(40689,'2023472','Robert Steven','Tzoy Tiño','Sexto','MA6BV','PE6BV','JV','Mecánica AutomotrizD','0007274578');
call sp_agregarPersona2(40690,'2023257','Angel Leonel','Magaña Torres','Sexto','IN6BV','PE6DV','JV','Computación','0007297127');
call sp_agregarPersona2(40691,'2023267','Edison Saul','Donis González','Sexto','IN6BV','PE6AV','JV','Computación','0007272211');
call sp_agregarPersona2(40692,'2020342','Aldo Misael','Lezana Rodriguez','Sexto','ET6AV','PE6CV','JV','Electrónica básica','0007314783');
call sp_agregarPersona2(40693,'2023218','Rodrigo Alejandro','Raymundo Ramírez','Sexto','DB6AV','PE6DV','JV','Dibujo Técnico','0007328201');
call sp_agregarPersona2(40694,'2023270','Fernando Javier','Tomás Velásquez','Sexto','IN6CM','PE6EM','JM','Computación','0005722513');
call sp_agregarPersona2(40695,'2020269','Ethan Jared Alberto','Juarez Pinto','Sexto','IN6BM','PE6BM','JM','Computación','0007996082');
call sp_agregarPersona2(40696,'2024235','Sergio Rodrigo','Pinetta Samayoa','Quinto ','MA5BV','PE5DV','JV','Mecánica Automotriz','0008026483');
call sp_agregarPersona2(40697,'2023135','Andrés Girahd','Bolaños Pineda','Quinto ','EB5AV','PE5CV','JV','Electrónica básica','0007301147');
call sp_agregarPersona2(40698,'2024387','Esdras Abdias','Tomas Burrion','Quinto ','EL5AV','PE5DV','JV','Electricidad Industrial','0007292595');
call sp_agregarPersona2(40699,'2024287','Stuardo Benjamin','Carvajal carias','Quinto ','EL5AV','PE5DV','JV','Electricidad Industrial','0007289285');
call sp_agregarPersona2(40700,'2024215','Jhonny Alejandro','Azurdia Garcia','Quinto ','EL5AV','PE5DV','JV','Electricidad Industrial','0007308331');
call sp_agregarPersona2(40701,'2024512','Marcos Arnoldo','Sian Santizo','Quinto ','MA5BM','PE5CM','JM','Mecánica Automotriz','0007308036');
call sp_agregarPersona2(40702,'2021010','Diego Alejandro','Sebastian Peña','Quinto ','IN5AM','PE5AM','JM','Computación','0007257210');
call sp_agregarPersona2(40703,'2025405','Anthony Sebastian','Aroche Sicajol','Cuarto ','MB4BV','PE4DV','JV','Mecánica Automotriz','0007305966');
call sp_agregarPersona2(40704,'2025265','Lucca alessandro','Cruz Quintana','Cuarto ','IN4CV','PE4DV','JV','Computación','0007298301');
call sp_agregarPersona2(40705,'2025553','Alex Fernando','Friely Reyes','Cuarto ','IN4CV','PE4DV','JV','Computación','0007315246');
call sp_agregarPersona2(40706,'2022296','César Dazahev','Chavez Escribá','Cuarto ','MB4AM','PE4AM','JM','Mecánica Automotriz','0007270426');
call sp_agregarPersona2(40707,'2022021','Miguel Angel','Santizo Zepeda','Cuarto ','IN4CM','PE4DM','JM','Computación','0007256684');
call sp_agregarPersona2(40708,'2022297','Luis Pedro','Vásquez Rodríguez','Cuarto ','IN4BM','PE4BM','JM','Computación','0007248746');
call sp_agregarPersona2(40709,'2025134','Abimael Adonai','Aguilar Moran','Cuarto ','EL4AM','PE4BM','JM','Electricidad Industrial','0007306672');
call sp_agregarPersona2(40710,'2021656','PABLO DAVID','VILLELA LOAIZA','Sexto','IN6BM','PE6DM','JM','Computación','0005508665');
call sp_agregarPersona2(40711,'2020478','José Pablo','Melgar Mayen','Sexto','IN6BM','PE6DM','JM','Computación','0005498415');
call sp_agregarPersona2(40712,'2020324','Anibal Guillermo','Herrera Ortiz','Sexto','IN6BM','PE6BM','JM','Computación','0008055606');
call sp_agregarPersona2(40713,'2023120','DIEGO ANDRÉ.','CHUPINA MÉNDEZ.','Sexto','IN6AV','PE6BV','JV','Computación','0007321336');
call sp_agregarPersona2(40714,'2023018','Paolo Isaac','Consuegra Martinez','Sexto','IN6AV','PE6BV','JV','Computación','0005558390');
call sp_agregarPersona2(40715,'2023253','Héctor Mauricio','Cordero Oliva','Sexto','IN6AV','PE6BV','JV','Computación','0005558385');
call sp_agregarPersona2(40716,'2023098','Dylan Emanuel','Julian Mucía','Sexto','IN6AV','PE6BV','JV','Computación','0005558439');
call sp_agregarPersona2(40717,'2023221','ANGEL YEUDIEL','VALENZUELA CAJAS','Sexto','MA6AM','PE6AM','JM','Mecánica Automotriz','0007282720');
call sp_agregarPersona2(40718,'2020598','Bernhardo Ignacio','Rivas Morales','Sexto','MA6AM','PE6AM','JM','Mecánica Automotriz','0007317699');
call sp_agregarPersona2(40719,'2020491','Fernando Javier','Paiz Azurdia','Sexto','MA6AM','PE6AM','JM','Mecánica Automotriz','0007304897');
call sp_agregarPersona2(40720,'2023193','Diego Antonio','Santiago del Cid','Sexto','EC6AM','PE6BM','JM','Electrónica básica','0005753417');
call sp_agregarPersona2(40721,'2020288','Denis Estuardo de Jesús','Ramírez Padilla','Sexto','EC6AM','PE6BM','JM','Electrónica básica','0007244466');
call sp_agregarPersona2(40722,'2020199','Jeffry Emanuel','Arenales López','Sexto','EC6AM','PE6BM','JM','Electrónica básica','0007332619');
call sp_agregarPersona2(40723,'2022067','José Andres','Aguirre Castillo','Sexto','EC6AM','PE6BM','JM','Electrónica básica','0007322384');
call sp_agregarPersona2(40724,'2023040','Ancel Ferdinand','Sawerbrey Flores','Sexto','DB6AM','PE6CM','JM','Dibujo Técnico','0007251109');
call sp_agregarPersona2(40725,'2023413','Mynor Javier','Melgar Huinac','Sexto','MA6BV','PE6BV','JV','Mecánica Automotriz','0005755950');
call sp_agregarPersona2(40726,'2023567','Ismael Isaac','Martin López','Sexto','MA6BV','PE6BV','JV','Mecánica Automotriz','0005755871');
call sp_agregarPersona2(40727,'2023255','Gabriel Josue','Arana Lezama','Sexto','EL6AM','PE6AM','JM','Electricidad Industrial','0005705040');
call sp_agregarPersona2(40728,'2023112','Diego Ángel Isaac','García Otuc','Sexto','IN6CM','PE6EM','JM','Computación','0007273453');
call sp_agregarPersona2(40729,'2023433','Brandon Gabriel','Soberanis López','Sexto','IN6CM','PE6EM','JM','Computación','0007244334');
call sp_agregarPersona2(40730,'2023009','Andrés Emilio','Coloma Tum','Sexto','IN6AM','PE6BM','JM','Computación','0008017468');
call sp_agregarPersona2(40731,'2020037','José Daniel','Aceituno Martínez','Sexto','IN6AM','PE6BM','JM','Computación','0008034274');
call sp_agregarPersona2(40732,'2020456','Angelo Leonardo Stephano','Del Cid Cheng','Sexto','MA6BM','PE6BM','JM','Mecánica Automotriz','0007262686');
call sp_agregarPersona2(40733,'2023166','Edward ceferino','Chile xunic','Sexto','MA6BM','PE6BM','JM','Mecánica Automotriz','0007289832');
call sp_agregarPersona2(40734,'2023514','Daniel Estuardo','Velásquez Quiñonez','Tercero','BA3BM','N/A','JM','Educación Básica','0007298760');
call sp_agregarPersona2(40735,'2020487','Diego Alejandro','Arreaga Burrion','Sexto','DB6AM','PE6CM','JM','Dibujo Técnico','0008001221');
call sp_agregarPersona2(40736,'2024107','Edison Danilo','Gomez Alonzo','Quinto ','MA5BV','PE5DV','JV','Mecánica Automotriz','0007291790');
call sp_agregarPersona2(40737,'2024428','Marvin Geovany','Huit Tepen','Quinto ','MA5BV','PE5DV','JV','Mecánica Automotriz','0007246341');
call sp_agregarPersona2(40738,'2024513','Alexis Esaú','de León Gómez','Quinto ','DB5AV','PE5AV','JV','Dibujo Técnico','0007299827');
call sp_agregarPersona2(40739,'2024283','Edgar Josue','Camey Ajsivinac','Quinto ','EL5AV','PE5DV','JV','Electricidad Industrial','0007322407');
call sp_agregarPersona2(40740,'2024009','Gabriel Nicolas','Monzón Avea','Quinto ','MA5BM','PE5CM','JM','Mecánica Automotriz','0005719565');
call sp_agregarPersona2(40741,'2024058','Dani Josue','Aguilar Santos','Quinto ','MA5AM','PE5AM','JM','Mecánica Automotriz','0007313919');
call sp_agregarPersona2(40742,'2023580','Diego Emmanuel','Yos Pinzón','Sexto','EC6AV','PE6CV','JV','Electrónica básica','0007324467');
call sp_agregarPersona2(40743,'2019147','Sebastian Enrique','Lemus  Salvador','Sexto','EC6AV','PE6CV','JV','Electrónica básica','0007330525');
call sp_agregarPersona2(40744,'2023495','Jefferson Yahir','González González','Sexto','EC6AV','PE6CV','JV','Electrónica básica','0007310510');
call sp_agregarPersona2(40745,'2024248','Otto Raul','Diaz Batres','Quinto ','IN5BV','PE5BV','JV','Computación','0007303359');
call sp_agregarPersona2(40746,'2024358','Benjamin Elí','Argueta Caal','Quinto ','IN5BV','PE5BV','JV','Computación','0007284396');
call sp_agregarPersona2(40747,'2024481','José Pablo','Canel Cumatz','Quinto ','DB5AV','PE5AV','JV','Dibujo Técnico','0007307113');
call sp_agregarPersona2(40748,'2024436','Justyn Juan Pablo','García Sequen','Quinto ','MA5BV','PE5DV','JV','Mecánica Automotriz','0007322338');
call sp_agregarPersona2(40749,'2023362','Gerald Asdrubal','Calderón Arauz','Tercero','BA3AM','N/A','JM','Educación Básica','0002752435');
call sp_agregarPersona2(40750,'2023364','David Alejandro','Jérez Cruz','Tercero','BA3AM','N/A','JM','Educación Básica','0002754149');
call sp_agregarPersona2(40751,'2023318','Jashua Carlos Rodrigo','Escobar Solano','Tercero','BA3EM','N/A','JM','Educación Básica','0013656237');
call sp_agregarPersona2(40752,'2023252','Otto Daniel','Sánchez Ramírez','Tercero','BA3EM','N/A','JM','Educación Básica','0008568160');
call sp_agregarPersona2(40753,'2024266','Rodrigo Imanol','Avila González','Segundo','BA2DM','N/A','JM','Educación Básica','0005614761');
call sp_agregarPersona2(40754,'2024308','Eduardo Armando','Chanchavac Caj','Segundo','BA2DM','N/A','JM','Educación Básica','0006843794');
call sp_agregarPersona2(40755,'2024451','Dylan Javier','Pérez Cardona','Segundo','BA2BM','N/A','JM','Educación Básica','0006674436');
call sp_agregarPersona2(40756,'2024473','Julián Alexander','Donis Castañeda','Segundo','BA2EM','N/A','JM','Educación Básica','0090965181');
call sp_agregarPersona2(40757,'2024068','Sebastián','Chun Rodríguez','Segundo','BA2EM','N/A','JM','Educación Básica','0006777204');
call sp_agregarPersona2(40758,'2024488','Juan Daniel','Maldonado Herrera','Segundo','BA2EM','N/A','JM','Educación Básica','0006765131');
call sp_agregarPersona2(40759,'2023508','Luis Fernando','Yumán Martínez','Segundo','BA2CM','N/A','JM','Educación Básica','0005091773');
call sp_agregarPersona2(40760,'2024157','Jeremy Francisco','Esquina Ramírez','Segundo','BA2CM','N/A','JM','Educación Básica','0006795515');
call sp_agregarPersona2(40761,'2024532','Kenny Alfonso','Castillo Polo','Segundo','BA2AM','N/A','JM','Educación Básica','0002857944');
call sp_agregarPersona2(40762,'2024088','Diego Alexander','Molina Castillo','Quinto ','IN5AM','PE5AM','JM','Computación','0007293127');
call sp_agregarPersona2(40763,'2020467','Francisco Angel Daniel','de la Cruz Cojón','Sexto','MA6BM','PE6BM','JM','Mecánica Automotriz','0007247524');
call sp_agregarPersona2(40764,'2020445','Raúl Stuardo','Sandoval Del Cid','Sexto','IN6AM','PE6DM','JM','Computación','0008019617');
call sp_agregarPersona2(40765,'2023367','Diego Alejandro','Felipe Chis','Sexto','EC6AV','PE6CV','JV','Electrónica básica','0007295860');
call sp_agregarPersona2(40766,'2023269','Anderson Ismael','López Florián','Sexto','IN6BV','PE6DV','JV','Computación','0007293888');
call sp_agregarPersona2(40767,'2023346','Derian Sebastián','Hernández González','Sexto','IN6BV','PE6AV','JV','Computación','0007313287');
call sp_agregarPersona2(40768,'2023325','Kevin David','Churunel Cobox','Sexto','EL6AM','PE6AM','JM','Electricidad Industrial','0004780340');
call sp_agregarPersona2(40769,'2023236','Alvaro Sebastian','Moran Elias','Sexto','EL6AM','PE6AM','JM','Electricidad Industrial','0004780335');
call sp_agregarPersona2(40770,'2023323','Carlos Antonio','Pacheco Kelly','Sexto','DB6AV','PE6DV','JV','Dibujo Técnico','0007251372');
call sp_agregarPersona2(40771,'2023273','Anthoni Josué','Lux Quiej','Sexto','DB6AV','PE6DV','JV','Dibujo Técnico','0007269753');
call sp_agregarPersona2(40772,'2023402','Ernesto Joaquín','Gonzalez olayo','Sexto','IN6CM','PE6EM','JM','Computación','0007300465');
call sp_agregarPersona2(40773,'2020412','Alejandro Rafael','Carrillo Cordon','Sexto','IN6CM','PE6EM','JM','Computación','0007993738');
call sp_agregarPersona2(40774,'2023296','Pedro Rafael','Salguero Salazar','Sexto','MA6AM','PE6AM','JM','Mecánica Automotriz','0007288910');
call sp_agregarPersona2(40775,'2021239','Miguel Alejandro','Sequén Reynoso','Sexto','MA6AM','PE6AM','JM','Mecánica Automotriz','0007302672');
call sp_agregarPersona2(40776,'2023029','Pablo Alejandro','Palacios Abascal','Sexto','IN6AV','PE6BV','JV','Computación','0007309215');
call sp_agregarPersona2(40777,'2024534','Emerson Emiliano','Davila Cabrera','Segundo','BA2BM','N/A','JM','Educación Básica','0001107959');
call sp_agregarPersona2(40778,'2024228','Abner Estuardo','Poz López','Segundo','BA2BM','N/A','JM','Educación Básica','0005509669');
call sp_agregarPersona2(40779,'2023571','Xavi Sebastián','García Garrido','Tercero','BA3AM','N/A','JM','Educación Básica','0002773287');
call sp_agregarPersona2(40780,'2024521','Esteban Xavier','Juárez Ramírez','Primero','BA1GM','N/A','JM','Educación Básica','0002742170');
call sp_agregarPersona2(40781,'2024319','Oswaldo Andres','López Ramírez','Segundo','BA2AM','N/A','JM','Educación Básica','0007651794');
call sp_agregarPersona2(40782,'2023175','Pedro Andres','Perez Chajon','Tercero','BA3EM','N/A','JM','Educación Básica','0008534234');
call sp_agregarPersona2(40783,'2022407','Josef Gabriel','Loaiza Farelo','Tercero','BA3EM','N/A','JM','Educación Básica','0007955738');
call sp_agregarPersona2(40784,'2024438','ELDER DANIEL','VELASCO GARCIA','Segundo','BA2EM','N/A','JM','Educación Básica','0006691481');
call sp_agregarPersona2(40785,'2024507','Brandon Daniel','Ixpanel Flores','Segundo','BA2EM','N/A','JM','Educación Básica','0091096440');
call sp_agregarPersona2(40786,'2023519','Fabian Alberto','Pérez Alvarado','Tercero','BA3CM','N/A','JM','Educación Básica','0002968481');
call sp_agregarPersona2(40787,'2024455','Joao Sebastián','Valenzuela Trigueros','Segundo','BA2DM','N/A','JM','Educación Básica','0005612501');
call sp_agregarPersona2(40788,'2024143','Luis Andreé','López Ajvix','Segundo','BA2DM','N/A','JM','Educación Básica','0006401872');
call sp_agregarPersona2(40789,'2023594','Sergio Gudiel C','Castro Peréz','Sexto','ET6AV','PE6CV','JV','Electrónica básica','0007322409');
call sp_agregarPersona2(40790,'2023121','Carlos Ramsés','López Orozco','Sexto','DB6AV','PE6DV','JV','Dibujo Técnico','0007318750');
call sp_agregarPersona2(40791,'2024391','Julio Josué','Reyes Cordero','Quinto ','DB5AV','PE5AV','JV','Dibujo Técnico','0007330427');
call sp_agregarPersona2(40792,'2024117','Mario Daniel','Santos Vasquez','Quinto ','DB5AV','PE5AV','JV','Dibujo Técnico','0007302063');
call sp_agregarPersona2(40793,'2024337','Angel Gabriel Ernesto','Grijalva Castro','Quinto ','IN5BV','PE5BV','JV','Computación','0007316002');
call sp_agregarPersona2(40794,'2024329','Pablo Josue','Hernandez Ortiz','Quinto ','IN5CV','PE5BV','JV','Computación','0007289970');
call sp_agregarPersona2(40795,'2024427','BYRON STEVE','PINEDA LUNA','Quinto ','IN5CV','PE5BV','JV','Computación','0007305733');
call sp_agregarPersona2(40796,'2024392','Wilson Matías','Florian Hernández','Quinto ','IN5CV','PE5BV','JV','Computación','0007284428');
call sp_agregarPersona2(40797,'2023513','Adrian Alejandro','Barrios Torres','Quinto ','EB5AV','PE5CV','JV','Electrónica básica','0007309337');
call sp_agregarPersona2(40798,'2024327','Henry Mauricio','Gil Velásquez','Quinto ','EB5AV','PE5CV','JV','Electrónica básica','0007246123');
call sp_agregarPersona2(40799,'2024138','Pedro Guillermo','Rozotto Estrada','Quinto ','EB5AM','PE5BM','JM','Electrónica básica','0007248149');
call sp_agregarPersona2(40800,'2024459','Randy Yair','Carrillo Pu','Quinto ','EB5AM','PE5BM','JM','Electrónica básica','0007289450');
call sp_agregarPersona2(40801,'2024404','Diego Andre','Alvarez Escoto','Quinto ','EL5AV','PE5DV','JV','Electricidad Industrial','0007287014');
call sp_agregarPersona2(40802,'2021240','Alejandro Manuel','Lopez Amperez','Quinto ','EL5AM','PE5BM','JM','Electricidad Industrial','0007261064');
call sp_agregarPersona2(40803,'2020495','Humberto Rafael','Castro Rodríguez','Sexto','IN6CV','PE6AV','JV','Computación','0007266780');
call sp_agregarPersona2(40804,'2023528','JEREMY JAIR','AREVALO GOMEZ','Sexto','IN6CV','PE6AV','JV','Computación','0007253573');
call sp_agregarPersona2(40805,'2023415','Jonathan Estuardo','Álvarez Aguilar','Sexto','IN6CV','PE6AV','JV','Computación','0007271140');
call sp_agregarPersona2(40806,'2020367','Nelson Isabel','López Ramos','Sexto','DB6AM','PE6CM','JM','Dibujo Técnico','0007270462');
call sp_agregarPersona2(40807,'2019182','Marlon Dario','Galicia López','Sexto','DB6AM','PE6CM','JM','Dibujo Técnico','0008020779');
call sp_agregarPersona2(40808,'2023065','Samuel Andrés','Coco Aguilar','Sexto','DB6AM','PE6CM','JM','Dibujo Técnico','0008040288');
call sp_agregarPersona2(40809,'2023104','Juan Sebastián','Caal Chinchilla','Sexto','DB6AM','PE6CM','JM','Dibujo Técnico','0008064878');
call sp_agregarPersona2(40810,'2023021','Alexis Lisandro','Monroy de la Cruz','Sexto','IN6BV','PE6DV','JV','Computación','0007274573');
call sp_agregarPersona2(40811,'2023336','Abner Josue','Del Cid Pirir','Sexto','IN6BV','PE6AV','JV','Computación','0007285309');
call sp_agregarPersona2(40812,'2023293','Andy Alejandro','Gómez Ruiz','Sexto','MA6BV','PE6BV','JV','Mecánica Automotriz','0007262768');
call sp_agregarPersona2(40813,'2023281','Pablo André','Castro Molina','Sexto','MA6BV','PE6BV','JV','Mecánica Automotriz','0008011300');
call sp_agregarPersona2(40814,'2020414','Alexander Daniel','González Vasquez','Sexto','EC6AM','PE6DM','JM','Electrónica básica','0007283976');
call sp_agregarPersona2(40815,'2023052','Fidel Eliseo Manases','Chitay Montúfar','Sexto','ET6AV','PE6CV','JV','Electrónica básica','0007303830');
call sp_agregarPersona2(40816,'2023110','José Pablo','Sazo Solares','Sexto','EC6AM','PE6BM','JM','Electrónica básica','0005753422');
call sp_agregarPersona2(40817,'2023012','Fredy Alexander','García Sicajau','Sexto','IN6BM','PE6BM','JM','Computación','0008006898');
call sp_agregarPersona2(40818,'2020376','Andres Alexander','Oliva Solares','Sexto','IN6AV','PE6BV','JV','Computación','0007289284');
call sp_agregarPersona2(40819,'2023074','Jose Luis Alejandro','Estrada Hernández','Sexto','IN6AV','PE6BV','JV','Computación','0007270237');
call sp_agregarPersona2(40820,'2023407','Jose Andres','Cordova Orellana','Sexto','MA6AM','PE6AM','JM','Mecánica Automotriz','0007296091');
call sp_agregarPersona2(40821,'2023337','Gustavo Adolfo','Cruz Jolón','Sexto','DB6AV','PE6DV','JV','Dibujo Técnico','0007261565');
call sp_agregarPersona2(40822,'2020066','Luis Javier','Pérez Monzón','Sexto','IN6CM','PE6EM','JM','Computación','0007276733');
call sp_agregarPersona2(40823,'2023163','Rodrigo Alfonso','Zarate Mauricio','Tercero','BA3CM','N/A','JM','Educación Básica','0006967832');
call sp_agregarPersona2(40824,'2023588','José Alejandro','Lopéz Villagrán','Tercero','BA3CM','N/A','JM','Educación Básica','0006836996');
call sp_agregarPersona2(40825,'2023607','Emilio Esteban','Méndez Rivas','Tercero','BA3AM','N/A','JM','Educación Básica','0002761012');
call sp_agregarPersona2(40826,'2023483','Denilson Alejandro','Rosales Alfaro','Tercero','BA3EM','N/A','JM','Educación Básica','0005961969');
call sp_agregarPersona2(40827,'2020581','Ian Andre','Castillo','Quinto ','DB5AV','PE5AV','JV','Dibujo Técnico','0007298591');
call sp_agregarPersona2(40828,'2024382','IAN OSWALDO','CONDE ESCOBAR','Quinto ','DB5AV','PE5AV','JV','Dibujo Técnico','0007283161');
call sp_agregarPersona2(40829,'2024110','Kenneth Omar','Castellanos Sicajá','Quinto ','MA5BV','PE5DV','JV','Mecánica Automotriz','0007288075');
call sp_agregarPersona2(40830,'2024190','Joan Saúl','Villagran palomo','Quinto ','MA5BM','PE5CM','JM','Mecánica Automotriz','0007280887');
call sp_agregarPersona2(40831,'2023499','Julio adolfo isaias','Acicon chacon','Quinto ','MA5BM','PE5CM','JM','Mecánica Automotriz','0007322612');
call sp_agregarPersona2(40832,'2021283','Dilan Alexis','Soriano Oajaca','Quinto ','MA5AM','PE5AM','JM','Mecánica Automotriz','0008036833');
call sp_agregarPersona2(40833,'2024326','Daniel Alberto','Aguilar Lemus','Quinto ','EL5AV','PE5DV','JV','Electricidad Industrial','0007307912');
call sp_agregarPersona2(40834,'2019427','Pether Anderson David','Reyes Guzmán','Sexto','ET6AV','PE6CV','JV','Electrónica básica','0007277988');
call sp_agregarPersona2(40835,'2023390','Juan Ignacio','Maldonado Rodriguez','Sexto','ET6AV','PE6CV','JV','Electrónica básica','0005558389');
call sp_agregarPersona2(40836,'2023224','Sebastian Alejandro','Romero Ordoñez','Sexto','ET6AV','PE6CV','JV','Electrónica básica','0007324928');
call sp_agregarPersona2(40837,'2020591','Johan Miguel','Tojin Acabal','Sexto','IN6BV','PE6DV','JV','Computación','0007265002');
call sp_agregarPersona2(40838,'2020584','Oliver Alexander','Sales Chocojay','Sexto','IN6BV','PE6DV','JV','Computación','0007245027');
call sp_agregarPersona2(40839,'2023357','Adrian Philip','Posadas del Cid','Sexto','IN6BV','PE6DV','JV','Computación','0005700709');
call sp_agregarPersona2(40840,'2023370','Ricardo Yichkan','Figueroa Juarez','Sexto','IN6BV','PE6AV','JV','Computación','0007329650');
call sp_agregarPersona2(40841,'2019644','Jefferson Osbely','Portillo Aguilar','Sexto','IN6CV','PE6AV','JV','Computación','0007286334');
call sp_agregarPersona2(40842,'2022220','Ludvin Irving Estuardo','Cabrera Hernández','Sexto','MA6BV','PE6BV','JV','Mecánica Automotriz','0008029186');
call sp_agregarPersona2(40843,'2020580','Cristopher Daniel','García Alecio','Sexto','MA6BV','PE6BV','JV','Mecánica Automotriz','0007286259');
call sp_agregarPersona2(40844,'2023172','Josue Alexander','Martínez Argueta','Sexto','EL6AM','PE6AM','JM','Electricidad Industrial','0005704563');
call sp_agregarPersona2(40845,'2023606','Eliseo Isaac','Pérez Osorio','Sexto','DB6AV','PE6DV','JV','Dibujo Técnico','0007291957');
call sp_agregarPersona2(40846,'2023406','Josivar Sebastian Rayjam','Alva López','Sexto','EC6AV','PE6CV','JV','Electrónica básica','0007280254');
call sp_agregarPersona2(40847,'2020368','Steven Alejandro','Escobar Matías','Sexto','MA6AM','PE6AM','JM','Mecánica Automotriz','0007311968');
call sp_agregarPersona2(40848,'2023421','André Sebastián','Montero Gonzalez','Sexto','EC6AM','PE6BM','JM','Electrónica básica','0007252753');
call sp_agregarPersona2(40849,'2020433','Gabriel Alexander','Pinula Jerónimo','Sexto','IN6AV','PE6BV','JV','Computación','0007328177');
call sp_agregarPersona2(40850,'2023132','Hugo Alexander','Reyes Veliz','Sexto','ET6AM','PE6EM','JM','Electrónica básica','0008026847');
call sp_agregarPersona2(40851,'2023119','Diego Javier','Coxaj Cabrera','Sexto','DB6AM','PE6CM','JM','Dibujo Técnico','0008028480');
call sp_agregarPersona2(40852,'2024500','José Andrés','Barrientos Agustín','Quinto ','DB5AV','PE5AV','JV','Dibujo Técnico','0007289579');
call sp_agregarPersona2(40853,'2023566','Elkyn Benjamin','Samayoa Samayoa','Sexto','IN6CV','PE6AV','JV','Computación','0007284831');
call sp_agregarPersona2(40854,'2020586','Harlin Williams','Palacios Alvarez','Sexto','IN6BV','PE6DV','JV','Computación','0007264110');
call sp_agregarPersona2(40855,'2023369','Kevin Andrés','Godinez Mejia','Tercero','BA3EM','N/A','JM','Educación Básica','0008511900');
call sp_agregarPersona2(40856,'2024267','Dylan Ottoniel','Choc Alonzo','Quinto ','MA5BV','PE5DV','JV','Mecánica Automotriz','0007325255');
call sp_agregarPersona2(40857,'2023118','José Antonio','Catalán Suc','Sexto','MA6BM','PE6BM','JM','Mecánica Automotriz','0007247214');
call sp_agregarPersona2(40858,'2023089','Christian Rafael','Pinto Hernández','Sexto','MA6AV','PE6CV','JV','Mecánica Automotriz','0005700791');
call sp_agregarPersona2(40859,'2022211','Ludim Rubén Alejandro','Hernández Olivares','Cuarto ','MB4AV','PE4CV','JV','Mecánica Automotriz','0005566381');
call sp_agregarPersona2(40860,'2022282','FERNANDO GABRIEL','MONTENEGRO BUSTAMANTE','Tercero','BA3CM','N/A','JM','Educación Básica','0007296629');
call sp_agregarPersona2(40861,'2025594','Lenny Alejandro','Moreira Dominguez','Cuarto ','EB4AV','PE4CV','JV','Electrónica básica','0005553771');
call sp_agregarPersona2(40862,'2025592','William Alexander','Otzoy Gonzalez','Cuarto ','IN4CV','PE4EV','JV','Computación','0005559614');
call sp_agregarPersona2(40863,'2025327','Rodrigo Alejandro','Medrano Mendez','Cuarto ','MB4AV','PE4AV','JV','Mecánica Automotriz','0007246748');
call sp_agregarPersona2(40864,'2023565','Diego Josué','Rodríguez Salazar','Tercero','BA3BM','N/A','JM','Educación Básica','0007284328');
call sp_agregarPersona2(40865,'2020292','Diego Andree','Urias Rivas','Sexto','IN6BM','N/A','JM','Computación','0008040156');
call sp_agregarPersona2(40866,'2020439','Javier Alejandro','Hernández Ochoa','Sexto','IN6BM','N/A','JM','Computación','0008075106');
call sp_agregarPersona2(40867,'2024347','DAVID FRANCISCO','LÓPEZ SICÁ','Quinto ','IN5BV','PE5BV','JV','Computación','0007284116');
call sp_agregarPersona2(40868,'2024369','Osman Emmanuell','Veliz Guzmán','Quinto ','IN5BV','PE5CV','JV','Computación','0007324603');
call sp_agregarPersona2(40869,'2019621','Daniel Alejandro','Reyes García','Quinto ','EB5BM','PE5DM','JM','Electrónica básica','0007265299');
call sp_agregarPersona2(40870,'2024213','Santiago Alessandro','Carranza Sánchez','Quinto ','DB5AV','PE5AV','JV','Dibujo Técnico','0007284721');
call sp_agregarPersona2(40871,'2020464','Fabían Alberto','Say Pérez','Quinto ','IN5AM','PE5AM','JM','Computación','0007249171');
call sp_agregarPersona2(40872,'2023489','Santiago Alejandro','Sandoval Hernández','Segundo','BA2CM','N/A','JM','Educación Básica','0000154314');
call sp_agregarPersona2(40873,'2024050','Mynor Esteban','Say Perez','Segundo','BA2AM','N/A','JM','Educación Básica','0007536689');
call sp_agregarPersona2(40874,'2024542','Pablo Camilo','Cifuentes Vásquez','Primero','BA1EM','N/A','JM','Educación Básica','0007245139');
call sp_agregarPersona2(40875,'2023550','Pablo Sebastian','Oliva Román','Tercero','BA3DM','N/A','JM','Educación Básica','0006812606');
call sp_agregarPersona2(40876,'2022058','Josè David','Zeròn Macario','Tercero','BA3AM','N/A','JM','Educación Básica','0007250790');
call sp_agregarPersona2(40877,'2023400','Juan Antonio','Sian Alvarado','Tercero','BA3BM','N/A','JM','Educación Básica','0005520399');
call sp_agregarPersona2(40878,'2020602','Kevin Manuel','Reyes Paz','Sexto «','IN6CV','N/A','JV','Computación','0008019587');
call sp_agregarPersona2(40879,'2022496','Freydman Nahum','Ajanel Pelico','Sexto «','EL6AM','N/A','JM','Electricidad Industrial','0008022365');
call sp_agregarPersona2(40880,'2022379','Kenneth Anthony Gabriel','Escobar González','Cuarto ','MB4AV','PE4AV','JM','Mecánica Automotriz','0007248512');
call sp_agregarPersona2(40881,'2025600','Paul Ricardo ','Sánchez Garcia','Cuarto ','EB4AV','PE4CV','JV','Electrónica básica','0007295647');
call sp_agregarPersona2(40882,'2025597','Cristian Alexander ','Pérez Alfaro','Cuarto ','IN4BV','PE4EV','JV','Computación','0007295312');
call sp_agregarPersona2(40883,'2025587','Joaquin Alejandro ','Paz Maldonado','Cuarto ','DB4AV','PE4BV','JM','Dibujo Técnico','0007314567');
call sp_agregarPersona2(40884,'2025566','Luis Alexander ','Ambrocio Reyes','Cuarto ','MB4AV','PE4CV','JM','Mecánica Automotriz','0007325939');
call sp_agregarPersona2(40885,'2021659','Sergio Roberto ','Morales Quinteros','Cuarto ','DB4AV','PE4DV','JV','Dibujo Técnico','0007328588');
call sp_agregarPersona2(40886,'2025575','Alan Enrique ','Cos Reyes','Cuarto ','IN4AV','PE4AV','JM','Computación','0007249186');
call sp_agregarPersona2(40887,'2023522','Carlos Roberto','Reyes Espinoza','Segundo','BA2CM','N/A','JM','Educación Básica','0005404385');
call sp_agregarPersona2(40888,'2023526','Javinsson Santiago','Aceituno Ortiz','Tercero','BA3AM','N/A','JM','Educación Básica','0002744969');
call sp_agregarPersona2(40889,'2022353','Angel yadiel','Mayen poroj','Tercero','BA3AM','N/A','JM','Educación Básica','0005553772');
call sp_agregarAsistencia(1,40659);
call sp_listarPersona();
call sp_listarAsistencia();