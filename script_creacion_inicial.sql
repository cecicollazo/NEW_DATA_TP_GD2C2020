USE GD2C2020

--Sentencia para que sea reejecutable el script

IF EXISTS(SELECT name FROM sys.tables WHERE name LIKE 'factura_auto_parte')
	DROP TABLE new_data.factura_auto_parte

IF EXISTS(SELECT name FROM sys.tables WHERE name LIKE 'factura_automovil')
	DROP TABLE new_data.factura_automovil

IF EXISTS(SELECT name FROM sys.tables WHERE name LIKE 'compra_auto_parte')
	DROP TABLE new_data.compra_auto_parte

IF EXISTS(SELECT name FROM sys.tables WHERE name LIKE 'compra_automovil')
	DROP TABLE new_data.compra_automovil

IF EXISTS(SELECT name FROM sys.tables WHERE name LIKE 'sucursal')
	DROP TABLE new_data.sucursal

IF EXISTS(SELECT name FROM sys.tables WHERE name LIKE 'auto_parte')
	DROP TABLE new_data.auto_parte

IF EXISTS(SELECT name FROM sys.tables WHERE name LIKE 'automovil')
	DROP TABLE new_data.automovil

IF EXISTS(SELECT name FROM sys.tables WHERE name LIKE 'fabricante')
	DROP TABLE new_data.fabricante

IF EXISTS(SELECT name FROM sys.tables WHERE name LIKE 'modelo')
	DROP TABLE new_data.modelo

IF EXISTS(SELECT name FROM sys.tables WHERE name LIKE 'tipo_transmision')
	DROP TABLE new_data.tipo_transmision

IF EXISTS(SELECT name FROM sys.tables WHERE name LIKE 'tipo_auto')
	DROP TABLE new_data.tipo_auto

IF EXISTS(SELECT name FROM sys.tables WHERE name LIKE 'tipo_caja')
	DROP TABLE new_data.tipo_caja

IF EXISTS(SELECT name FROM sys.tables WHERE name LIKE 'tipo_motor')
	DROP TABLE new_data.tipo_motor

IF EXISTS(SELECT name FROM sys.tables WHERE name LIKE 'cliente')
	DROP TABLE new_data.cliente

IF OBJECT_ID('new_data.compra_de_automovil', 'P') IS NOT NULL
	DROP PROCEDURE new_data.compra_de_automovil

IF OBJECT_ID('new_data.facturacion_venta_de_automovil', 'P') IS NOT NULL
	DROP PROCEDURE new_data.facturacion_venta_de_automovil

IF OBJECT_ID('new_data.compra_de_auto_partes', 'P') IS NOT NULL
	DROP PROCEDURE new_data.compra_de_auto_partes

IF OBJECT_ID('new_data.facturacion_venta_de_auto_partes', 'P') IS NOT NULL
	DROP PROCEDURE new_data.facturacion_venta_de_auto_partes

IF OBJECT_ID('new_data.migracion_datos', 'P') IS NOT NULL
	DROP PROCEDURE new_data.migracion_datos
GO

IF EXISTS(SELECT name FROM sys.schemas WHERE name LIKE 'new_data')
	DROP SCHEMA new_data
GO

--Creacion del esquema para las tablas

CREATE SCHEMA new_data
GO

--Creacion de tablas segun DER (hay cambios)

CREATE TABLE new_data.cliente (
	cliente_codigo DECIMAL (9) IDENTITY PRIMARY KEY,
	cliente_apellido NVARCHAR (510),
	cliente_nombre NVARCHAR (510),
	cliente_direccion NVARCHAR (510),
	cliente_DNI DECIMAL (9),
	cliente_fecha_nac DATETIME2 (7),
	cliente_mail NVARCHAR (510),
	);

CREATE TABLE new_data.tipo_motor (
	tipo_motor_codigo DECIMAL (9) PRIMARY KEY
	);

CREATE TABLE new_data.tipo_caja (
	tipo_caja_codigo DECIMAL (9) PRIMARY KEY,
	tipo_caja_descripcion NVARCHAR (510)
	);

CREATE TABLE new_data.tipo_auto (
	tipo_auto_codigo DECIMAL (9) PRIMARY KEY,
	tipo_auto_descripcion NVARCHAR (510)
	);

CREATE TABLE new_data.tipo_transmision (
	tipo_transmision_codigo DECIMAL (9) PRIMARY KEY,
	tipo_transmision_descripcion NVARCHAR (510)
	);

CREATE TABLE new_data.modelo (
	modelo_codigo DECIMAL (9) PRIMARY KEY,
	modelo_nombre NVARCHAR (510),
	modelo_potencia DECIMAL (9),
	tipo_motor_codigo DECIMAL (9) REFERENCES new_data.tipo_motor,
	tipo_caja_codigo DECIMAL (9) REFERENCES new_data.tipo_caja,
	tipo_auto_codigo DECIMAL (9) REFERENCES new_data.tipo_auto,
	tipo_transmicion_codigo DECIMAL (9) REFERENCES new_data.tipo_transmision
    );

CREATE TABLE new_data.fabricante (
	fabricante_codigo DECIMAL (9) IDENTITY PRIMARY KEY,
	fabricante_nombre NVARCHAR (510)
	);

CREATE TABLE new_data.automovil (
	auto_codigo DECIMAL (9) IDENTITY PRIMARY KEY,
	auto_patente NVARCHAR (100),
	auto_nro_chasis NVARCHAR (100),
	auto_nro_motor NVARCHAR (100),
	auto_fecha_alta DATETIME2 (7),
	auto_cant_kms DECIMAL (9),
	modelo_codigo DECIMAL (9) REFERENCES new_data.modelo,
	fabricante_codigo DECIMAL (9) REFERENCES new_data.fabricante
	);

CREATE TABLE new_data.auto_parte (
	auto_parte_codigo DECIMAL (9) PRIMARY KEY,
	auto_parte_descripcion NVARCHAR (510),
	modelo_codigo DECIMAL (9) REFERENCES new_data.modelo,
	fabricante_codigo DECIMAL (9) REFERENCES new_data.fabricante,
	auto_parte_categoria NVARCHAR (510)
	);

CREATE TABLE new_data.sucursal (
	sucursal_codigo DECIMAL (9) IDENTITY PRIMARY KEY,
	sucursal_direccion NVARCHAR (510),
	sucursal_mail NVARCHAR (510),
	sucursal_telefono DECIMAL (9),
	sucursal_ciudad NVARCHAR (510)
	);

CREATE TABLE new_data.compra_automovil (
	compra_automovil_codigo DECIMAL (9) IDENTITY PRIMARY KEY,
	compra_automovil_nro DECIMAL (9),
	compra_automovil_fecha DATETIME2 (7),
	compra_automovil_precio DECIMAL (9),
	auto_codigo DECIMAL (9) REFERENCES new_data.automovil,
	sucursal_codigo DECIMAL (9) REFERENCES new_data.sucursal
	);

CREATE TABLE new_data.compra_auto_parte (
	compra_auto_parte_codigo DECIMAL (9) IDENTITY PRIMARY KEY,
	compra_auto_parte_nro DECIMAL (9),
	compra_auto_parte_fecha DATETIME2 (7),
	compra_auto_parte_precio DECIMAL (9),
	compra_auto_parte_cant DECIMAL (9),
	auto_parte_codigo DECIMAL (9) REFERENCES new_data.auto_parte,
	sucursal_codigo DECIMAL (9) REFERENCES new_data.sucursal
	);

CREATE TABLE new_data.factura_automovil (
	factura_automovil_codigo DECIMAL (9) IDENTITY PRIMARY KEY,
	factura_automovil_nro DECIMAL (9),
	factura_automovil_fecha DATETIME2 (7),
	factura_automovil_precio_facturado DECIMAL (9),
	cliente_codigo DECIMAL (9) REFERENCES new_data.cliente,
	auto_codigo DECIMAL (9) REFERENCES new_data.automovil,
	sucursal_codigo DECIMAL (9) REFERENCES new_data.sucursal
	);

CREATE TABLE new_data.factura_auto_parte (
	factura_auto_parte_codigo DECIMAL (9) IDENTITY PRIMARY KEY,
	factura_auto_parte_nro DECIMAL (9),
	factura_auto_parte_fecha DATETIME2 (7),
	factura_auto_parte_precio_facturado DECIMAL (9),
	factura_auto_parte_cant_facturada DECIMAL (9),
	cliente_codigo DECIMAL (9) REFERENCES new_data.cliente,
	auto_parte_codigo DECIMAL (9) REFERENCES new_data.auto_parte,
	sucursal_codigo DECIMAL (9) REFERENCES new_data.sucursal
	);
GO

--Se crean los sp de los casos de uso

--Carga de datos por la compra de un automovil

CREATE PROCEDURE new_data.compra_de_automovil
@sucursal_codigo DECIMAL (9),
@auto_patente NVARCHAR (100),
@auto_nro_chasis NVARCHAR (100),
@auto_nro_motor NVARCHAR (100),
@auto_fecha_alta DATETIME2 (7),
@auto_cant_kms DECIMAL (9),
@modelo_codigo DECIMAL (9),
@fabricante_codigo DECIMAL (9),
@compra_automovil_nro DECIMAL (9),
@compra_automovil_precio DECIMAL (9)
AS
BEGIN
    DECLARE @auto_codigo DECIMAL (9)
    INSERT INTO new_data.automovil VALUES (@auto_patente, @auto_nro_chasis, @auto_nro_motor, @auto_fecha_alta, @auto_cant_kms, @modelo_codigo, @fabricante_codigo)
    SELECT @auto_codigo = SCOPE_IDENTITY()

    INSERT INTO new_data.compra_automovil (compra_automovil_nro, compra_automovil_fecha, compra_automovil_precio, auto_codigo, sucursal_codigo)
    VALUES (@compra_automovil_nro, CONVERT(DATETIME2 (7), GETDATE()), @compra_automovil_precio, @auto_codigo, @sucursal_codigo)
END
GO

--Carga de datos por la venta de un automovil (facturacion)

CREATE PROCEDURE new_data.facturacion_venta_de_automovil
@auto_codigo DECIMAL (9),
@sucursal_codigo DECIMAL (9),
@factura_automovil_nro DECIMAL (9)
AS
BEGIN
    DECLARE @factura_automovil_precio_facturado DECIMAL (9) = (SELECT compra_automovil_precio FROM new_data.compra_automovil WHERE auto_codigo = @auto_codigo) * 1.2

	INSERT INTO new_data.factura_automovil (factura_automovil_nro, factura_automovil_fecha, factura_automovil_precio_facturado, sucursal_codigo, auto_codigo)
	VALUES (@factura_automovil_nro, CONVERT(DATETIME2 (7), GETDATE()), @factura_automovil_precio_facturado, @sucursal_codigo, @auto_codigo)
END
GO

--Carga de datos por la compra de autopartes

CREATE PROCEDURE new_data.compra_de_auto_partes
@auto_parte_codigo DECIMAL (9),
@auto_parte_cantidad DECIMAL (9),
@auto_parte_descripcion NVARCHAR (510),
@modelo_codigo DECIMAL (9),
@fabricante_codigo DECIMAL (9),
@categoria NVARCHAR(510),
@sucursal_codigo DECIMAL (9),
@compra_auto_parte_precio DECIMAL (9)
AS
BEGIN
	IF NOT EXISTS(SELECT auto_parte_codigo FROM new_data.auto_parte WHERE auto_parte_codigo = @auto_parte_codigo)
	BEGIN
		INSERT INTO new_data.auto_parte
		VALUES (@auto_parte_codigo, @auto_parte_descripcion, @modelo_codigo, @fabricante_codigo, @categoria)
	END

    INSERT INTO new_data.compra_auto_parte (compra_auto_parte_nro, compra_auto_parte_fecha, compra_auto_parte_precio, compra_auto_parte_cant, auto_parte_codigo, sucursal_codigo)
    VALUES (SCOPE_IDENTITY(), CONVERT(DATETIME2 (7), GETDATE()), @compra_auto_parte_precio, @auto_parte_cantidad, @auto_parte_codigo, @sucursal_codigo)
END
GO

--Carga de datos por la venta de autopartes (facturacion)

CREATE PROCEDURE new_data.facturacion_venta_de_auto_partes
@cliente_codigo DECIMAL (9),
@sucursal_codigo DECIMAL (9),
@auto_parte_codigo DECIMAL (9),
@factura_auto_parte_cant_facturada DECIMAL (9),
@factura_auto_parte_nro DECIMAL (9)
AS
BEGIN
    DECLARE @factura_auto_parte_precio_facturado DECIMAL (9) = (SELECT compra_auto_parte_precio FROM new_data.compra_auto_parte WHERE auto_parte_codigo = @auto_parte_codigo) * 1.2
	
    INSERT INTO new_data.factura_auto_parte (factura_auto_parte_nro, factura_auto_parte_fecha, factura_auto_parte_precio_facturado, factura_auto_parte_cant_facturada, cliente_codigo, auto_parte_codigo, sucursal_codigo)
	VALUES (@factura_auto_parte_nro, CONVERT(DATETIME2 (7), GETDATE()), @factura_auto_parte_precio_facturado, @factura_auto_parte_cant_facturada, @cliente_codigo, @auto_parte_codigo, @sucursal_codigo)
END
GO

--Creo el sp que realiza la migracion

CREATE PROCEDURE new_data.migracion_datos
AS
	BEGIN

	--Inserto datos en tabla clientes

		INSERT INTO new_data.cliente
		SELECT DISTINCT CLIENTE_APELLIDO, CLIENTE_NOMBRE, CLIENTE_DIRECCION, CLIENTE_DNI, CLIENTE_FECHA_NAC, CLIENTE_MAIL
		FROM gd_esquema.Maestra
		WHERE CLIENTE_DNI IS NOT NULL

		INSERT INTO new_data.cliente
		SELECT DISTINCT FAC_CLIENTE_APELLIDO, FAC_CLIENTE_NOMBRE, FAC_CLIENTE_DIRECCION, FAC_CLIENTE_DNI, FAC_CLIENTE_FECHA_NAC,
						FAC_CLIENTE_MAIL
		FROM gd_esquema.Maestra
		WHERE FAC_CLIENTE_DNI IS NOT NULL AND FAC_CLIENTE_DNI NOT IN (SELECT cliente_DNI FROM new_data.cliente)

	--Inserto datos en tabla tipo_motor

		INSERT INTO new_data.tipo_motor
		SELECT DISTINCT TIPO_MOTOR_CODIGO
		FROM gd_esquema.Maestra
		WHERE TIPO_MOTOR_CODIGO IS NOT NULL

	--Inserto datos en tabla tipo_caja

        INSERT INTO new_data.tipo_caja
		SELECT DISTINCT TIPO_CAJA_CODIGO, TIPO_CAJA_DESC
		FROM gd_esquema.Maestra
		WHERE TIPO_CAJA_CODIGO IS NOT NULL

	--Inserto datos en tabla tipo_auto

        INSERT INTO new_data.tipo_auto
		SELECT DISTINCT TIPO_AUTO_CODIGO, TIPO_AUTO_DESC
		FROM gd_esquema.Maestra
		WHERE TIPO_AUTO_CODIGO IS NOT NULL

	--Inserto datos en tabla tipo_transmision

        INSERT INTO new_data.tipo_transmision
		SELECT DISTINCT TIPO_TRANSMISION_CODIGO, TIPO_TRANSMISION_DESC
		FROM gd_esquema.Maestra
		WHERE TIPO_TRANSMISION_CODIGO IS NOT NULL

	--Inserto datos en tabla modelo

		INSERT INTO new_data.modelo
		SELECT DISTINCT MODELO_CODIGO, MODELO_NOMBRE, MODELO_POTENCIA, new_data.tipo_motor.tipo_motor_codigo,
						new_data.tipo_caja.tipo_caja_codigo, new_data.tipo_auto.tipo_auto_codigo,
						new_data.tipo_transmision.tipo_transmision_codigo
		FROM gd_esquema.Maestra
			JOIN new_data.tipo_motor ON Maestra.TIPO_MOTOR_CODIGO = new_data.tipo_motor.tipo_motor_codigo
			JOIN new_data.tipo_caja ON Maestra.TIPO_CAJA_CODIGO = new_data.tipo_caja.tipo_caja_codigo
			JOIN new_data.tipo_auto ON Maestra.TIPO_AUTO_CODIGO = new_data.tipo_auto.tipo_auto_codigo
			JOIN new_data.tipo_transmision ON Maestra.TIPO_TRANSMISION_CODIGO = new_data.tipo_transmision.tipo_transmision_codigo
		WHERE Maestra.TIPO_MOTOR_CODIGO IS NOT NULL

	--Inserto datos en tabla fabricante

		INSERT INTO new_data.fabricante
		SELECT DISTINCT FABRICANTE_NOMBRE
		FROM gd_esquema.Maestra
		WHERE FABRICANTE_NOMBRE IS NOT NULL

	--Inserto datos en tabla automovil

		INSERT INTO new_data.automovil
		SELECT DISTINCT AUTO_PATENTE, AUTO_NRO_CHASIS, AUTO_NRO_MOTOR, AUTO_FECHA_ALTA, AUTO_CANT_KMS,
						new_data.modelo.modelo_codigo, new_data.fabricante.fabricante_codigo
		FROM gd_esquema.Maestra
			JOIN new_data.modelo ON Maestra.MODELO_CODIGO = new_data.modelo.modelo_codigo
			JOIN new_data.fabricante ON Maestra.FABRICANTE_NOMBRE = new_data.fabricante.fabricante_nombre
		WHERE AUTO_PATENTE IS NOT NULL

	--Inserto datos en tabla auto_parte

        INSERT INTO new_data.auto_parte
		SELECT DISTINCT AUTO_PARTE_CODIGO, AUTO_PARTE_DESCRIPCION, new_data.modelo.modelo_codigo, fabricante_codigo, NULL
		FROM gd_esquema.Maestra
			JOIN new_data.modelo ON Maestra.MODELO_CODIGO = modelo.modelo_codigo
			JOIN new_data.fabricante ON Maestra.FABRICANTE_NOMBRE = new_data.fabricante.fabricante_nombre
		WHERE Maestra.AUTO_PARTE_CODIGO IS NOT NULL

	--Inserto datos en tabla sucursal

		INSERT INTO new_data.sucursal
		SELECT DISTINCT SUCURSAL_DIRECCION, SUCURSAL_MAIL, SUCURSAL_TELEFONO, SUCURSAL_CIUDAD
		FROM gd_esquema.Maestra
		WHERE SUCURSAL_DIRECCION IS NOT NULL

	--Inserto datos en tabla compra_automovil

		INSERT INTO new_data.compra_automovil
		SELECT DISTINCT COMPRA_NRO, COMPRA_FECHA, COMPRA_PRECIO, new_data.automovil.auto_codigo,
						new_data.sucursal.sucursal_codigo
		FROM gd_esquema.Maestra
			JOIN new_data.automovil ON Maestra.AUTO_PATENTE = new_data.automovil.auto_patente
			JOIN new_data.sucursal ON Maestra.SUCURSAL_DIRECCION = new_data.sucursal.sucursal_direccion
        WHERE Maestra.COMPRA_NRO IS NOT NULL


	--Inserto datos en tabla compra_auto_parte

		INSERT INTO new_data.compra_auto_parte
		SELECT DISTINCT COMPRA_NRO, COMPRA_FECHA, COMPRA_PRECIO, COMPRA_CANT, new_data.auto_parte.auto_parte_codigo,
						new_data.sucursal.sucursal_codigo
		FROM gd_esquema.Maestra
			JOIN new_data.auto_parte ON Maestra.AUTO_PARTE_CODIGO = new_data.auto_parte.auto_parte_codigo
			JOIN new_data.sucursal ON Maestra.SUCURSAL_DIRECCION = new_data.sucursal.sucursal_direccion
		WHERE Maestra.COMPRA_NRO IS NOT NULL

	--Inserto datos en tabla factura_automovil

		INSERT INTO new_data.factura_automovil
		SELECT DISTINCT FACTURA_NRO, FACTURA_FECHA, PRECIO_FACTURADO, new_data.cliente.cliente_codigo,
						new_data.automovil.auto_codigo, new_data.sucursal.sucursal_codigo
		FROM gd_esquema.Maestra
			JOIN new_data.cliente ON Maestra.FAC_CLIENTE_DNI = new_data.cliente.cliente_DNI
			JOIN new_data.automovil ON Maestra.AUTO_PATENTE = new_data.automovil.auto_patente
			JOIN new_data.sucursal ON Maestra.FAC_SUCURSAL_DIRECCION = new_data.sucursal.sucursal_direccion
		WHERE Maestra.FACTURA_NRO IS NOT NULL

	--Inserto datos en tabla factura_auto_parte

		INSERT INTO new_data.factura_auto_parte
		SELECT DISTINCT FACTURA_NRO, FACTURA_FECHA, PRECIO_FACTURADO, CANT_FACTURADA, new_data.cliente.cliente_codigo,
						new_data.auto_parte.auto_parte_codigo, new_data.sucursal.sucursal_codigo
		FROM gd_esquema.Maestra
			JOIN new_data.cliente ON Maestra.FAC_CLIENTE_DNI = new_data.cliente.cliente_DNI
			JOIN new_data.auto_parte ON Maestra.AUTO_PARTE_CODIGO = new_data.auto_parte.auto_parte_codigo
			JOIN new_data.sucursal ON Maestra.FAC_SUCURSAL_DIRECCION = new_data.sucursal.sucursal_direccion
		WHERE Maestra.FACTURA_NRO IS NOT NULL

	END
GO

--Se ejecuta el proceso de migracion de datos

EXEC new_data.migracion_datos
GO

DROP PROCEDURE new_data.migracion_datos
GO