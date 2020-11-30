USE GD2C2020

GO

--Sentencia para que sea reejecutable el script

IF OBJECT_ID('new_data.BI_operacion_auto_parte', 'U') IS NOT NULL
    DROP TABLE new_data.BI_operacion_auto_parte;
IF OBJECT_ID('new_data.BI_operacion_automovil', 'U') IS NOT NULL
    DROP TABLE new_data.BI_operacion_automovil;
IF OBJECT_ID('new_data.BI_operacion_fecha', 'U') IS NOT NULL
    DROP TABLE new_data.BI_operacion_fecha;
IF OBJECT_ID('new_data.BI_cliente', 'U') IS NOT NULL
    DROP TABLE new_data.BI_cliente;
IF OBJECT_ID('new_data.BI_sucursal', 'U') IS NOT NULL
    DROP TABLE new_data.BI_sucursal;
IF OBJECT_ID('new_data.BI_auto_parte', 'U') IS NOT NULL
    DROP TABLE new_data.BI_auto_parte;
IF OBJECT_ID('new_data.BI_automovil', 'U') IS NOT NULL
    DROP TABLE new_data.BI_automovil;
IF EXISTS(SELECT name FROM sys.objects WHERE type_desc LIKE '%fun%' AND name LIKE 'BI_f_rango_x_edad')
    DROP FUNCTION new_data.BI_f_rango_x_edad
IF EXISTS(SELECT name FROM sys.objects WHERE type_desc LIKE '%fun%' AND name LIKE 'BI_f_rango_x_potencia')
    DROP FUNCTION new_data.BI_f_rango_x_potencia
IF EXISTS(SELECT name FROM sys.objects WHERE type_desc LIKE '%fun%' AND name LIKE 'BI_f_stock_x_mes')
    DROP FUNCTION new_data.BI_f_stock_x_mes
IF OBJECT_ID('new_data.BI_view_compraventa_automoviles_x_sucursal_y_mes', 'V') IS NOT NULL
    DROP VIEW new_data.BI_view_compraventa_automoviles_x_sucursal_y_mes;
IF OBJECT_ID('new_data.BI_view_precio_promedio_automoviles_compraventa', 'V') IS NOT NULL
    DROP VIEW new_data.BI_view_precio_promedio_automoviles_compraventa;
IF OBJECT_ID('new_data.BI_view_ganancias_automoviles_x_sucursal_y_mes', 'V') IS NOT NULL
    DROP VIEW new_data.BI_view_ganancias_automoviles_x_sucursal_y_mes;
IF OBJECT_ID('new_data.BI_view_promedio_de_tiempo_stock_x_modelo', 'V') IS NOT NULL
    DROP VIEW new_data.BI_view_promedio_de_tiempo_stock_x_modelo;
IF OBJECT_ID('new_data.BI_view_precio_promedio_auto_partes_compraventa', 'V') IS NOT NULL
    DROP VIEW new_data.BI_view_precio_promedio_auto_partes_compraventa;
IF OBJECT_ID('new_data.BI_view_ganancias_auto_partes_x_sucursal_y_mes', 'V') IS NOT NULL
    DROP VIEW new_data.BI_view_ganancias_auto_partes_x_sucursal_y_mes;
IF OBJECT_ID('new_data.BI_view_maxima_cant_stock_x_sucursal_anual', 'V') IS NOT NULL
    DROP VIEW new_data.BI_view_maxima_cant_stock_x_sucursal_anual;

--Creacion de tablas
    
CREATE TABLE new_data.BI_operacion_fecha(
    fecha_codigo DECIMAL (9) IDENTITY PRIMARY KEY,
	fecha_mes_numero INT,
	fecha_mes_nombre NVARCHAR(510),
	fecha_anio_numero INT,
	);

CREATE TABLE new_data.BI_cliente(
	cliente_codigo DECIMAL (9) PRIMARY KEY,
	cliente_sexo NVARCHAR(510),
	cliente_rango_edad NVARCHAR(510),
	);

CREATE TABLE new_data.BI_sucursal(
	sucursal_codigo DECIMAL (9) PRIMARY KEY,
	sucursal_direccion NVARCHAR (510),
	sucursal_mail NVARCHAR (510),
	sucursal_telefono DECIMAL (9),
	sucursal_ciudad NVARCHAR (510)
	);

CREATE TABLE new_data.BI_auto_parte(
    auto_parte_codigo DECIMAL (9) PRIMARY KEY,
	auto_parte_descripcion NVARCHAR (510),
	fabricante_nombre NVARCHAR (510),
	auto_parte_categoria NVARCHAR (510)
	);

CREATE TABLE new_data.BI_automovil(
	auto_codigo DECIMAL (9) PRIMARY KEY,
	modelo_nombre NVARCHAR (510),
	modelo_potencia NVARCHAR (510),
	fabricante_nombre NVARCHAR (510),
	tipo_auto_codigo DECIMAL (9),
	tipo_caja_codigo DECIMAL (9),
	tipo_motor_codigo DECIMAL (9),
	tipo_transmision_codigo DECIMAL (9),
	cantidad_de_cambios INT, -- NULL por ausencia de info en el modelo
    );

CREATE TABLE new_data.BI_operacion_auto_parte(
	operacion_codigo DECIMAL (9) IDENTITY PRIMARY KEY,
	operacion_tipo VARCHAR(510),
	operacion_monto_unitario DECIMAL(18,2),
	cliente_codigo DECIMAL (9) FOREIGN KEY REFERENCES new_data.BI_cliente(cliente_codigo),
	auto_parte_codigo DECIMAL (9) FOREIGN KEY REFERENCES new_data.BI_auto_parte(auto_parte_codigo),
	fecha_codigo DECIMAL (9) FOREIGN KEY REFERENCES new_data.BI_operacion_fecha(fecha_codigo),
	sucursal_codigo DECIMAL (9) FOREIGN KEY REFERENCES new_data.BI_sucursal(sucursal_codigo),
	operacion_cantidad DECIMAL(18,2)
    );

CREATE TABLE new_data.BI_operacion_automovil(
    operacion_codigo DECIMAL (9) IDENTITY PRIMARY KEY,
    operacion_tipo VARCHAR(510),
    operacion_monto DECIMAL(9),
	cliente_codigo DECIMAL (9) FOREIGN KEY REFERENCES new_data.BI_cliente(cliente_codigo),
    auto_codigo DECIMAL (9) FOREIGN KEY REFERENCES new_data.BI_automovil(auto_codigo),
	fecha_codigo DECIMAL (9) FOREIGN KEY REFERENCES new_data.BI_operacion_fecha(fecha_codigo),
	sucursal_codigo DECIMAL (9) FOREIGN KEY REFERENCES new_data.BI_sucursal(sucursal_codigo),
    );

GO

--Funciones

CREATE FUNCTION new_data.BI_f_rango_x_edad(@fecha_nacimiento DATETIME2)
RETURNS NVARCHAR(255)
AS
BEGIN
    IF(DATEDIFF(YEAR, @fecha_nacimiento, GETDATE()) BETWEEN 18 AND 30)
	BEGIN
		RETURN '18-30'
	END
	IF(DATEDIFF(YEAR, @fecha_nacimiento, GETDATE()) BETWEEN 31 AND 50)
	BEGIN
		RETURN '31-50'
	END
	IF(DATEDIFF(YEAR, @fecha_nacimiento, GETDATE()) > 50)
	BEGIN
		RETURN '>50'
	END
	    RETURN NULL
END
GO

CREATE FUNCTION new_data.BI_f_rango_x_potencia(@potencia decimal(18,0))
RETURNS NVARCHAR(255)
AS
BEGIN
	IF(@potencia BETWEEN 50 AND 150)
	BEGIN
		RETURN '50-150cv'
	END
	IF(@potencia BETWEEN 151 AND 300)
	BEGIN
		RETURN '151-300cv'
	END
	IF(@potencia > 300)
	BEGIN
		RETURN '>300cv'
	END
	    RETURN NULL
END
GO

CREATE FUNCTION new_data.BI_f_stock_x_mes(@anio INT, @mes INT, @sucursal DECIMAL (9))
RETURNS INT
AS
BEGIN
	RETURN(
		SELECT
		SUM(CASE operacion_tipo WHEN 'COMPRA' THEN operacion_cantidad ELSE 0 END)-
		SUM(CASE operacion_tipo WHEN 'VENTA' THEN operacion_cantidad ELSE 0 END)
		FROM new_data.BI_operacion_auto_parte
		INNER JOIN new_data.BI_operacion_fecha ON BI_operacion_fecha.fecha_codigo = BI_operacion_auto_parte.fecha_codigo
		WHERE sucursal_codigo = @sucursal
		AND fecha_anio_numero * 12 + fecha_mes_numero <= @anio * 12 + @mes
		)
END
GO

--Carga de datos de cliente

INSERT INTO new_data.BI_cliente
SELECT cliente_codigo, NULL, new_data.BI_f_rango_x_edad(cliente_fecha_nac)
FROM GD2C2020.new_data.cliente

--Carga de datos de sucursal

INSERT INTO new_data.BI_sucursal
SELECT * FROM GD2C2020.new_data.sucursal

--Carga de datos de autoparte

INSERT INTO new_data.BI_auto_parte
SELECT auto_parte_codigo, auto_parte_descripcion, fabricante_nombre, auto_parte_categoria
FROM GD2C2020.new_data.auto_parte
    INNER JOIN GD2C2020.new_data.modelo ON modelo.modelo_codigo = auto_parte.modelo_codigo
    INNER JOIN GD2C2020.new_data.fabricante ON fabricante.fabricante_codigo = auto_parte.fabricante_codigo

--Carga de datos de automovil

INSERT INTO new_data.BI_automovil
SELECT auto_codigo, modelo_nombre, new_data.BI_f_rango_x_potencia(modelo_potencia), fabricante_nombre,
       tipo_auto_codigo, tipo_caja_codigo, tipo_motor_codigo, tipo_transmicion_codigo, NULL
FROM GD2C2020.new_data.automovil
    INNER JOIN GD2C2020.new_data.modelo ON modelo.modelo_codigo = automovil.modelo_codigo
    INNER JOIN GD2C2020.new_data.fabricante ON fabricante.fabricante_codigo = automovil.fabricante_codigo
GO

--Carga de datos de fecha de operacion

CREATE TABLE #fechasexistente(
	fecha DATETIME2(3)
)
INSERT INTO #fechasexistente
SELECT compra_automovil_fecha FROM GD2C2020.new_data.compra_automovil UNION
SELECT factura_automovil_fecha FROM GD2C2020.new_data.factura_automovil UNION
SELECT compra_auto_parte_fecha FROM GD2C2020.new_data.compra_auto_parte UNION
SELECT factura_auto_parte_fecha FROM GD2C2020.new_data.factura_auto_parte

SET LANGUAGE 'Spanish';

INSERT INTO new_data.BI_operacion_fecha
SELECT DISTINCT MONTH(fecha), DATENAME(MONTH, fecha),YEAR(fecha)
FROM #fechasexistente

DROP TABLE #fechasexistente
GO

--Carga de datos de operacion automovil

INSERT INTO new_data.BI_operacion_automovil
SELECT 'COMPRA', compra_automovil_precio, cliente_codigo, auto_codigo, fecha_codigo, sucursal_codigo
FROM GD2C2020.new_data.compra_automovil
    INNER JOIN new_data.BI_operacion_fecha ON YEAR(compra_automovil_fecha) = fecha_anio_numero
                                          AND MONTH(compra_automovil_fecha) = fecha_mes_numero
UNION
SELECT 'VENTA', factura_automovil_precio_facturado, cliente_codigo, auto_codigo, fecha_codigo, sucursal_codigo
FROM GD2C2020.new_data.factura_automovil
    INNER JOIN new_data.BI_operacion_fecha ON YEAR(factura_automovil_fecha) = fecha_anio_numero
                                          AND MONTH(factura_automovil_fecha) = fecha_mes_numero

--Carga de datos de operacion autoparte
INSERT INTO new_data.BI_operacion_auto_parte
SELECT 'COMPRA', compra_auto_parte_precio, cliente_codigo, auto_parte_codigo, fecha_codigo, sucursal_codigo,
       compra_auto_parte_cant
FROM GD2C2020.new_data.compra_auto_parte
    INNER JOIN new_data.BI_operacion_fecha ON YEAR(compra_auto_parte_fecha) = fecha_anio_numero
                                          AND MONTH(compra_auto_parte_fecha) = fecha_mes_numero
UNION
SELECT 'VENTA', factura_auto_parte_precio_facturado, cliente_codigo, auto_parte_codigo, fecha_codigo, sucursal_codigo,
       factura_auto_parte_cant_facturada
FROM GD2C2020.new_data.factura_auto_parte
    INNER JOIN new_data.BI_operacion_fecha ON YEAR(factura_auto_parte_fecha) = fecha_anio_numero
                                          AND MONTH(factura_auto_parte_fecha) = fecha_mes_numero
GO

--Vistas Automovil

--Cantidad de autom�viles, vendidos y comprados x sucursal y mes

CREATE VIEW new_data.BI_view_compraventa_automoviles_x_sucursal_y_mes AS
SELECT sucursal_direccion 'Direcci�n de la sucursal', fecha_mes_nombre 'Mes',
	   COUNT(CASE operacion_tipo WHEN 'COMPRA' THEN 1 ELSE NULL END) 'Automoviles Comprados',
	   COUNT(CASE operacion_tipo WHEN 'VENTA' THEN 1 ELSE NULL END) 'Automoviles vendidos'
FROM new_data.BI_operacion_automovil
	INNER JOIN new_data.BI_sucursal ON BI_sucursal.sucursal_codigo = BI_operacion_automovil.sucursal_codigo
	INNER JOIN new_data.BI_operacion_fecha ON BI_operacion_fecha.fecha_codigo = BI_operacion_automovil.fecha_codigo
GROUP BY sucursal_direccion, fecha_mes_nombre
GO

--Precio promedio de autom�viles, vendidos y comprados.

CREATE VIEW new_data.BI_view_precio_promedio_automoviles_compraventa AS
SELECT
	AVG(CASE operacion_tipo WHEN 'COMPRA' THEN operacion_monto ELSE NULL END) 'Precio Promedio de Automoviles Comprados',
	AVG(CASE operacion_tipo WHEN 'VENTA' THEN operacion_monto ELSE NULL END) 'Precio promedio de automoviles vendidos'
FROM new_data.BI_operacion_automovil
GO

--Ganancias (precio de venta � precio de compra) x Sucursal x mes

CREATE VIEW new_data.BI_view_ganancias_automoviles_x_sucursal_y_mes AS
SELECT sucursal_direccion AS 'Direcci�n de la sucursal', fecha_mes_nombre AS 'Mes',
	   (SUM(CASE operacion_tipo WHEN 'VENTA' THEN operacion_monto ELSE 0 END) -
	    SUM(CASE operacion_tipo WHEN 'COMPRA' THEN operacion_monto ELSE 0 END)) 'Ganancias por automoviles'
FROM new_data.BI_operacion_automovil
	INNER JOIN new_data.BI_sucursal ON BI_sucursal.sucursal_codigo = BI_operacion_automovil.sucursal_codigo
	INNER JOIN new_data.BI_operacion_fecha ON BI_operacion_fecha.fecha_codigo = BI_operacion_automovil.fecha_codigo
GROUP BY sucursal_direccion, fecha_mes_nombre
GO

--Promedio de tiempo en stock de cada modelo de automóvil

CREATE VIEW new_data.BI_view_promedio_de_tiempo_stock_x_modelo AS
SELECT Modelo,
       AVG((Fecha_anio_venta-Fecha_anio_compra)*12+(Fecha_mes_venta-Fecha_mes_compra)) 'Promedio de meses en stock'
FROM
	(SELECT operacion1.auto_codigo Automovil, automovil.modelo_nombre Modelo,
	fecha_compra.fecha_anio_numero 'Fecha_anio_compra',
	fecha_compra.fecha_mes_numero 'Fecha_mes_compra',
	ISNULL(fecha_venta.fecha_anio_numero, YEAR(GETDATE())) AS [Fecha_anio_venta],
	ISNULL(fecha_venta.fecha_mes_numero,MONTH(GETDATE())) AS [Fecha_mes_venta]
	FROM new_data.BI_operacion_automovil operacion1
	INNER JOIN new_data.BI_automovil automovil ON automovil.auto_codigo = auto_codigo
	LEFT JOIN new_data.BI_operacion_automovil operacion2 ON operacion1.auto_codigo = operacion2.auto_codigo AND operacion2.operacion_tipo!=operacion1.operacion_tipo
	INNER JOIN new_data.BI_operacion_fecha fecha_compra ON fecha_compra.fecha_codigo=operacion1.fecha_codigo
	LEFT JOIN new_data.BI_operacion_fecha fecha_venta ON fecha_venta.fecha_codigo=operacion2.fecha_codigo
	WHERE operacion1.operacion_tipo='COMPRA'
	) fechasdecompraventa
GROUP BY Modelo
GO

--Vistas Autopartes

--Precio promedio de cada autoparte, vendida y comprada.

CREATE VIEW new_data.BI_view_precio_promedio_auto_partes_compraventa AS
SELECT auto_parte_codigo 'Autoparte',
	   AVG(CASE operacion_tipo WHEN 'COMPRA' THEN operacion_monto_unitario ELSE NULL END) 'Precio promedio de compra',
	   AVG(CASE operacion_tipo WHEN 'VENTA' THEN operacion_monto_unitario ELSE NULL END) 'Precio promedio de venta'
FROM new_data.BI_operacion_auto_parte
GROUP BY auto_parte_codigo
GO

--Ganancias (precio de venta � precio de compra) x Sucursal x mes

CREATE VIEW new_data.BI_view_ganancias_auto_partes_x_sucursal_y_mes AS
SELECT sucursal_direccion AS 'Direcci�n de la sucursal', fecha_mes_nombre AS 'Mes',
	   (SUM(CASE operacion_tipo WHEN 'VENTA' THEN (operacion_monto_unitario*operacion_cantidad) ELSE 0 END) -
	   SUM(CASE operacion_tipo WHEN 'COMPRA' THEN (operacion_monto_unitario*operacion_cantidad) ELSE 0 END))
	   'Ganancias por autopartes'
FROM new_data.BI_operacion_auto_parte
	INNER JOIN new_data.BI_sucursal ON BI_sucursal.sucursal_codigo = BI_operacion_auto_parte.sucursal_codigo
	INNER JOIN new_data.BI_operacion_fecha ON BI_operacion_fecha.fecha_codigo = BI_operacion_auto_parte.fecha_codigo
GROUP BY sucursal_direccion, fecha_mes_nombre
GO

--M�xima cantidad de stock por cada sucursal (anual)

CREATE VIEW new_data.BI_view_maxima_cant_stock_x_sucursal_anual AS
SELECT DISTINCT sucursal_direccion Sucursal, fecha_anio_numero A�o,
				MAX(new_data.BI_f_stock_x_mes(fecha_anio_numero, fecha_mes_numero, BI_operacion_auto_parte.sucursal_codigo))
				OVER(PARTITION BY sucursal_direccion, fecha_anio_numero) Stock
FROM new_data.BI_operacion_auto_parte
	INNER JOIN new_data.BI_operacion_fecha ON BI_operacion_fecha.fecha_codigo = BI_operacion_auto_parte.fecha_codigo
	INNER JOIN new_data.BI_sucursal ON BI_sucursal.sucursal_codigo = BI_operacion_auto_parte.sucursal_codigo
GROUP BY sucursal_direccion, BI_operacion_auto_parte.sucursal_codigo, fecha_anio_numero, fecha_mes_numero
