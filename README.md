# wue-lettuce-atacama-desert

### Análisis exploratorio del efecto de dos ambientes de invernadero de bajo costo en la costa del desierto de Atacama sobre la Eficiencia del Uso del Agua (WUE) en lechugas producidas hidropónicamente con agua de niebla.

> ## :warning: DISCLAIMER :warning:
> ### :books: Sobre la creación de este repositorio
> Este repositorio corresponde al trabajo final del curso **AGP3141 - Visualización de Datos Ambientales** de la Facultad de Agronomía y Sistemas Naturales de la Pontificia Universidad Católica de Chile, impartido por la profesora **Sara Acevedo**. 
> Lo que se muestra aquí es la idea preliminar de la tesis de doctorado de **Inés Vilches**.
>
> ### :robot: Sobre los datos de este repositorio
> Este repositorio contiene datos que no son reales.
> 
> Los datos contenidos en los documentos que inician como *"data-raw"* fueron **creados con inteligencia artificial**, específicamente con Chat GPT, para trabajar los contenidos del curso. 
>
> Los datos etiquetados como *"data-literature"* fueron obtenidos de **fuentes oficiales**, tales como documentos gubernamentales o papers de investigación.
>
> Al final de esta sección se detalla el prompt utilizado para la obtención de los datos.
>
> El README, las figuras y los scripts están en español ya que la investigación se realizó en Chile, pero las carpetas y la estructura general están en inglés para un entendimiento general abierto a investigadores internacionales en colaboración. 


## :book: Resumen
El Desierto de Atacama, si bien es el lugar más árido del planeta, cuenta con un recurso que podría cambiar la agricultura de esta zona: la niebla costera. 

A partir de los resultados del proyecto Fondecyt 13220028 (2023-2025), donde se identificó la factibilidad de realizar cultivos hidropónicos con agua de niebla en Iquique y Chañaral, se propone estudiar cómo aumentar la eficiencia en el uso del agua para producir con este recurso en invernaderos localizados en la costa del Desierto de Atacama, donde confluyen condiciones de alta radiación y aridez. 


## :file_folder: Estructura del repositorio
```
wue-lettuce-atacama-desert
├── README.md
├── data/
│   └── data-raw/
      └── data-raw-hobo-inside.xlsx
      └── data-raw-hobo-outside.xlsx
      └── data-raw-lettuce.xlsx
      └── data-raw-pool.xlsx
│   └── data-literature/
      └── data-literature-food-insecurity.xlsx
      └── data-literature-fog.xlsx
      └── data-literature-pib-sap.xlsx
      └── data-literature-precipitation.xlsx
├── scripts/
    ├── 01-plot-fog-comparative.R
    ├── 02-plot-growth-curve-lettuce.R
    └── 03-*(tbb)*
└── plots/
    ├── 01-plot-fog-comparative.png
    ├── 02-plot-growth-curve-lettuce.png
    └── 03-*(tbb)*
└── images-/
    ├── 01-shelf-jumbo-santiago1
    ├── 02-shelf-jumbo-santiago2
    └── 03-fogcollector-chañaral
    └── 04-
    └── 05-*(tbb)*

```

## :desert: ¿Por qué es importante producir en el desierto?

### *Problema principal*

Pongámonos en el siguiente escenario. 

Aprovechas una pequeña ventana de la universidad para ir a comprar una ensalada para tu almuerzo. Decides pasar desde el Campus San Joaquín al Jumbo, que está a dos estaciones de metro y te ofrece una gran variedad de dónde escoger. En el pasillo de las verduras ves una estantería repleta de lechugas, todas preciosas, pero una es notoriamente más pequeña que las demás e incluso se ve algo añeja. ¿Quién compraría esa lechuga, teniendo todas las demás disponibles? 

<p align="center">
  <img src="images/01-gondola-jumbo-santiago-.JPEG" width="45%" alt="gondola-lejos">
  <img src="images/02-gondola-jumbo-santiago2.JPEG" width="45%" alt="gondola-cerca">
</p>

Ahora te encuentras en Chañaral. No hay supermercado, por lo que para buscar tu lechuga debes ir la esquina donde "El Pino”, el caballero de las verduras, se para cada viernes junto a su camioneta con el pick-up abierto esperando a que escojas lo que quieres llevar de su selección. Ahora esa lechuga pequeña, notoriamente añeja y algo amarillenta es la mejor opción. El Pino te dice que es lo que quedó de su viaje a La Serena del lunes, después de haber vendido en Inca de Oro, Diego de Almagro y El Salado. Si quisieras otra cosa tendrías que ir al Unimarc que está en el pueblo vecino, Barquito, pero escuchaste que por un accidente en la ruta 5 no llegó la carga de la semana. 

Esta es la realidad de muchas localidades del Desierto de Atacama. Las condiciones de extrema aridez no permiten el florecimiento de una agricultura local que abastezca al 7% de la población de Chile que vive allí. Así, los alimentos deben viajar desde otras localidades, pasando largas horas arriba de un camión antes de arribar a los consumidores. La fragilidad del sistema queda reflejada en la alta inseguridad alimentaria que sufre esta zona, en promedio 20,5%, a pesar de albergar las regiones de mayores ingresos dedicadas a la producción de cobre (Yáñez, et al. 2023). 

### *Antecedentes*

Existe una fuente de agua que no ha sido altamente considerada hasta el momento. El agua de niebla, o camanchaca, inunda por las noches la costa del desierto más árido del mundo, dejando tras su paso litros de agua que son posibles de capturar con el invento chileno donado a la UNESCO, el atrapanieblas. 

<table>
    </td>
    <td width="50%">
      <img src="images/08-niebla-patache.JPEG"
           alt="Niebla en Alto Patache"
           width="100%">
      </td>
    <td width="50%">
      <img src="images/04-atrapanieblas-chañaral.JPEG"
           alt="Atrapanieblas en Chañaral"
           width="100%">
    </td>
  </tr>
</table>


El proyecto Fondecyt 13220028, realizado entre 2023 y 2025, demostró que esta agua tiene condiciones de calidad aptas para la producción hidropónica. Gracias a este proyecto fue posible producir lechugas hidropónicas en invernaderos de bajo costo ubicados en dos localidades de la costa del Desierto de Atacama: Alto Patache, 70 km al sur de Iquique, y Falda Verde, Chañaral. Así, fue posible producir lechugas con tan solo 3 L de agua por planta, cuando en producciones en suelo de la zona central esta cifra se mueve alrededor de los 100 L por planta.

Las siguientes fotografías muestran cómo funciona el invernadero y cómo se veía la producción en su interior:

<table>
    </td>
    <td width="60%">
      <img src="images/09-funcionamiento-invernadero.jpg"
           alt="Diagrama funcionamiento invernadero"
           width="100%">
      </td>
    <td width="40%">
      <img src="images/10-invernadero-chañaral.JPEG"
           alt="Foto interior invernadero Chañaral"
           width="100%">
    </td>
  </tr>
</table>


A continuación es posible observar los sitios de estudios y la cantidad de agua captada a partir de la niebla en dichas localidades. La cantidad de agua captada se mide en litros por m² de malla. 
El mapa de las localidades y de los litros de agua de niebla colectados se obtuvieron de Albornoz et al. (2023). 

<table>
    </td>
    <td width="35%">
      <img src="images/07-mapa-lugares-estudio.png"
           alt="Mapa localidades invernadero de agua de niebla"
           width="100%">
      </td>
    <td width="65%">
      <img src="plot/02-grafico-niebla-comparativo.png"
           alt="Captación de agua de niebla"
           width="100%">
    </td>
  </tr>
</table>

Considerando estos antecedentes, tenemos una fuente de agua que, si bien no llevará a reemplazar el sistema actual, sí puede ayudar a complementarlo y así fortalecer la seguridad alimentaria de la zona. Pero seguimos estando en una zona de alta aridez, por lo que es necesario utilizarla con gran eficiencia. Entonces, ¿cuáles son las condiciones de producción que nos pueden llevar a maximizar la cantidad de kilos producidos por litro de agua? Eso es lo que busca dilucidar esta investigación. 

### *Qué busca esta investigación*

Buscamos aumentar la eficiencia del uso del agua en producciones de lechugas hidropónicas de un invernadero localizado en la costa de Tarapacá mediante la manipulación de la temperatura, radiación y déficit de presión de vapor. A través de distintos ambientes de un invernadero de bajo costo, tanto en invierno como en verano, se evaluará qué condiciones ambientales son las que llevan a una mayor producción de kilos por litro de agua bajo las condiciones ambientales de extrema aridez del desierto de Atacama. 

## :question: Preguntas exploratorias
1. ¿Qué ambiente permite producir la mayor cantidad de kilos por litro de agua en lechuga hidropónica a los 28 días después de trasplante?
2. El ambiente donde se produce la mayor eficiencia de agua gravimétrica a cosecha, ¿es el mismo donde se produce la mayor eficiencia del uso de agua fisiológica?
3. ¿Cómo se modifica la Eficiencia en el Uso del Agua en los distintos ambientes a medida que las lechugas crecen en el invernadero?

## :microscope: Resultados

### Ambiente de invernadero

### Eficiencia del Uso del Agua a los 28 días de trasplante
Respondiendo la pregunta 1: 

*¿Qué ambiente permite producir la mayor cantidad de kilos por litro de agua en lechuga hidropónica a los 28 días después de trasplante?*

Conocida generalmente como la Eficiencia del Uso del Agua gravimétrica, analizamos en qué ambiente obtuvimos una mayor cantidad de kilos por litro de agua.

### Comparación Eficiencia del Uso del Agua gravimétrica y fisiológica
Respondiendo la pregunta 2: 

*El ambiente donde se produce la mayor eficiencia de agua gravimétrica a cosecha, ¿es el mismo donde se produce la mayor eficiencia del uso de agua fisiológica?*

### Evolución Eficiencia del Uso del Agua a partir del crecimiento de las lechugas
Respondiendo la pregunta 3:

*¿Cómo se modifica la Eficiencia en el Uso del Agua en los distintos ambientes a medida que las lechugas crecen en el invernadero?*

## :books: Bibliografía
- Albornoz, F.; del Río, C.; Carter, V.; Escobar, R.; Vásquez, L. (2023). Fog Water Collection for Local Greenhouse Vegetable Production in the Atacama Desert. Sustainability, 15, 15720. https://doi.org/10.3390/su152215720
- Yáñez, R., Navea, J., & Jara, B. (2023). Inseguridad alimentaria en Chile: una perspectiva multidimensional. https://rimisp.org/inseguridad-alimentaria-en-chile-una-perspectiva-multidimensional/

## :robot: Prompt Chat GPT
Para mi análisis de Eficiencia en el Uso del Agua, necesitaba los siguientes datos:
- Producción de lechuga (data-raw-lettuce).
- Consumo de agua de las lechugas (data-raw-pool).
- Datos ambientales de invernadero (data-raw-hobo-inside y data-raw-hobo-outside)

### :leafy_green: data-raw-lettuce
Como base, partí con una planilla excel donde yo asigné las columnas y la base de los datos de identificación:

| Nombre columna | Significado | Valores |
|---|---|---|
| # | ID de cada entrada, en número | 1-1792 |
| ID | ID de cada entrada, en letras | a-bpx |
| pool | Número de la piscina de producción | 1-8 |
| season | Temporada de producción | winter - summer |
| treatment | Tratamiento ambiental del invernadero | 1 y 2 |
| rep | Repetición por tratamiento y temporada | 1 y 2 |
| date-dat | Día después de trasplante | 1-28 |
| date-week | Semana de producción | 1-4 |
| date-calendar | Fecha del calendario | Desde 1 mayo 2026 a 28 febrero 2027 |
| lettuce-number-id | ID para cada lechuga. Indica season-pool.datedat-treatment-rep |  Ej: inv-1.1-T1R1|
| fresh-weight_root_g | Peso fresco raíz | Indicado en el prompt |
| dry-weight_root_g | Peso seco raíz | Indicado en el prompt |
| fresh-weight_leaves_g | Peso fresco hojas | Indicado en el prompt |
| dry-weight_leaves_g | Peso seco hojas | Indicado en el prompt |
| leaf-area_leaves_cm2 | Área de las hojas | Indicado en el prompt |
| A_leaves_umol-m2-s1 | Fotosíntesis neta (umol Co2 m-2 s-1) | Indicado en el prompt |
| E_leaves_umol-m2-s1 | Transpiración (umol H20 m-2 s-1) | Indicado en el prompt |
| gs_leaves_umol-m2-s1 | Conductancia estomática (umol H2O m-2 s-1) | Indicado en el prompt |

**Para los datos "Indicado en el prompt", esto fue lo indicado a Chat GPT:**

*Necesito que puedas crear datos ficticios en una planilla Excel. Para crear los datos del treatment 1, toma de referencia este Excel y en la hoja "lettuce" necesito que hagas lo siguiente:*

*-Para la **columna "ID"**, completa las letras correspondientes para el total de entrada de datos.*

*-Rellena los datos de peso fresco, peso seco, área foliar, A, E, gs en base a lo siguiente:*

   *-Los datos están agrupados para las piscinas o "pool" de la 1 a la 8. Cada piscina tiene 28 datos, 1 por cada día calendario. El orden de los datos va desde la piscina 1, temporada invierno, tratamiento 1 y repetición 1 con sus 28 días para luego seguir con las piscinas desde la 2 a la 8. Posteriormente, sigue con la temporada invierno, tratamiento 1 y repetición 2, luego tratamiento 2, repetición 1 y tratamiento 2 rep 2; luego temporada verano, tratamiento 1, repetición 1, temporada verano, tratamiento 1, repetición 2, temporada verano, tratamiento 2, rep 1 y finalmente temporada verano, tratamiento 2, rep 2.*
   
  *-Para rellenar la columna de **fresh-weight_leaves_g**, este valor va progresivamente aumentando desde el día 1 hasta el 28. El mínimo valor que podemos obtener de las lechugas en el día 1 va en 15,02 g y el máximo en el día 28 llega a 158,89 g en invierno y 236,68 en verano.*
  
*-Para rellenar la columna de **dry-weight_leaves_g**, este valor va progresivamente aumentando desde el día 1 hasta el 28. El mínimo valor que podemos obtener de las lechugas en el día 1 va en 0,71 g y el máximo en el día 28 llega a 7,13 g en invierno y 10,29 en verano.*

  *-Para rellenar la columna de **leaf-area_leaves_cm2**, este valor va progresivamente aumentando desde el día 1 hasta el 28. El mínimo valor que podemos obtener de las lechugas en el día 1 va en 0,08 g y el máximo en el día 28 llega a 210,34 g en invierno y 245,81 en verano.*

*Luego, agrega los datos para:*

*-**fresh-weight_root_g**: el valor mínimo es 2,34 en invierno y 3,98 en verano; el valor máximo es 20,6 en invierno y 25,89 en verano.*

*-**dry-weight_root_g**: el valor mínimo es 0,08 en invierno y 0,16 en verano; el valor máximo es 0,9 en invierno y 1,22 en verano.*

*-Los valores de **A, E y gs** por favor asignalos tú según valores típicos de crecimiento para lechuga, considerando, además de la diferencia entre tratamientos, que en invierno los valores sean menores que en verano.*

*Necesito que crees los datos para el tratamiento 2 considerando los valores que ya existen para el tratamiento 1, pero ahora con que existan diferencias entre el T1 y el T2 de entre un 25 y un 40%, obteniendo mayores diferencias en verano. Considera que T2>T1*

*Además, agrega diferencias entre las repeticiones para poder realizar barras de error. Las diferencias pueden ir entre un 1-35% y son aleatorias en su magnitud, no habiendo una relación de mayor/menor establecida como en el caso de los tratamientos.*

*Por último, introduce algunos errores aleatorios a los datos de las mesas. Los errores se deberán a que el dato se saldrá de rango para los valores normales de una lechuga en al menos una cifra (por ejemplo, en vez de 20 gramos en una raíz, que diga 200, en vez de 200 de peso fresco de hojas, que diga 2000, etc).*

### :droplet: data-raw-pool
La base de los datos identificatorios siguió la misma lógica de la planilla data-raw-lechugas, solo con nuevos datos que eran exclusivos para el agua. 

| Nombre columna | Significado | Valores |
|---|---|---|
| # | ID de cada entrada, en número | 1-1792 |
| ID | ID de cada entrada, en letras | a-bpx |
| pool | Número de la piscina de producción | 1-8 |
| season | Temporada de producción | winter - summer |
| treatment | Tratamiento ambiental del invernadero | 1 y 2 |
| rep | Repetición por tratamiento y temporada | 1 y 2 |
| date-dat | Día después de trasplante | 1-28 |
| date-week | Semana de producción | 1-4 |
| date-calendar | Fecha del calendario | Desde 1 mayo 2026 a 28 febrero 2027 |
| total-plants_pool_n | Total de lechugas disponibles en la mesa para cada fecha | 42-15|
| ns-volume_pool_l | Volumen de agua disponible en la mesa | Indicado en el prompt |
| ph_pool_no-unit | pH de la solución nutritiva | Indicado en el prompt |
| ce_pool_ds-m | Conductividad eléctrica de la solución nutritiva | Indicado en el prompt |

- Se debe considerar que se asumió que por cada día se cosechaba una lechuga de cada mesa, por lo que se agregó la columna "total-plants_pool_n" que identifica cuántas lechugas van quedando con el paso de los días. Cada mesa iniciaba con 42 lechugas y luego de 28 días de producción terminaba con 15 plantas.

- Para **ns-volume_pool_l** se consideró que se partía con un volumen inicial de agua el que va disminuyendo con el paso de los días y no hay rellenos entremedio de la producción, solo al inicio de cada ciclo.

**Para los datos "Indicado en el prompt", esto fue lo indicado a Chat GPT:**

*Para la hoja "water" necesito que crees los siguientes datos para estas columnas:*

*-Columna **ns-volume_pool_l**:*

  *-El consumo de agua debe aumentar progresivamente desde el día 1 hasta el día 28, siguiendo el crecimiento de las lechugas indicado en la hoja "lettuce", creada anteriormente.*
  
  *-Los valores deben presentar variabilidad diaria y entre piscinas, evitando patrones perfectamente lineales.*

  *-El consumo de agua debe ser mayor durante el verano que durante el invierno, debido a las mayores demandas evaporativas.*

  *-El día date-dat 1 debe partir con valores alrededor de 150, mientras que el día date-dat 28 debe terminar con valores alrededor de 28. Considera dos decimales.*

***Diferencias entre tratamientos:***

*-Considera diferencias en el consumo de agua entre T1 y T2.*

*-Los valores deben ser coherentes con las diferencias de crecimiento y biomasa existentes entre ambos tratamientos.*

*-Las diferencias deben considerar las condiciones de cada temporada.*

*-El consumo acumulado de agua debe aumentar durante todo el período de crecimiento.*

*-Debe existir variabilidad entre piscinas y repeticiones.*

*Introduce algunos errores aleatorios a los datos de las mesas. En el caso del volumen, los errores se deberán a que el dato se saldrá de rango en al menos una cifra (por ejemplo, en vez de 20 litros, que diga 200). En el pH, el error pueden ser valores negativos o sobre 14. y en el Ce, la existencia de números negativos o por sobre 100.*

*Como resultado, entrega una nueva planilla Excel con los datos completos de consumo diario de agua, manteniendo la estructura original.*


### :house_with_garden: data-raw-hobo-inside y data-raw-hobo-outside

Como base, las columnas de la planilla excel son las siguientes (los datos cambiaron a hobo_in o hobo_out dependiendo de si los datos meteorológicos son medidos dentro o fuera del invernadero):

| Nombre columna | Significado | Valores admitidos|
|---|---|---|
| N° | ID de cada entrada, en número | 1 - 43776 |
| date_hobo-in_iso / date_hobo-out_iso| Fecha de cada dato | Desde mayo 2026 a febrero 2027 (sin NA) |
| time_hobo-in_HHmmss / time_hobo-out_HHmmss| Hora de cada dato | Datos cada 10 minutos (sin NA) |
| radiation_hobo-in_umol-m2-s1 / radiation_hobo-out_umol-m2-s1 | Dato de sensor de radiación PAR | 0 - 2200 (sin NA) |
| temperature_hobo-in_C / temperature_hobo-out_C | Dato de sensor de temperatura | 0 - 50 (sin NA) |
| hr_hobo-in_% / hr_hobo-out_% | Dato de sensor de humedad relativa | 1 - 100 (sin NA) |

**Para los datos "Indicado en el prompt", esto fue lo indicado a Chat GPT:**

*Tomando como referencia este Excel, necesito que generes datos ambientales ficticios para las hojas "envir-inside" y "envir-outside", considerando lo siguiente:*


***1. Organización de los datos***

*-Los registros deben generarse cada 10 minutos.*

*-Fecha de inicio: 1-may-26.*

*-Fecha de término: 28-feb-27.*

*-Mantén el formato de fecha 2026-05-01.*

*-Las mediciones deben cubrir las 24 horas del día.*



***2. Datos ambientales dentro del invernadero (envir-inside)***


***Radiación solar:***

*-Durante la noche, la radiación debe mantenerse en 1,2 µmol m⁻² s⁻¹.*

*-En invierno, considera horario nocturno entre las 18:00 y las 09:00.*

*-En verano, considera horario nocturno entre las 19:40 y las 08:00.*

*-Durante el día, la radiación debe aumentar progresivamente durante la mañana, alcanzar sus valores máximos alrededor del mediodía y disminuir durante la tarde.*

*-Los valores deben presentar diferencias estacionales, con mayor radiación en verano que en invierno.*

*-Incorpora fluctuaciones naturales asociadas a nubosidad y eventos de niebla.*


***Temperatura:***

*-Genera variaciones diarias y estacionales coherentes con las condiciones de un invernadero ubicado en Iquique.*

*-La temperatura debe aumentar durante la mañana, alcanzar valores máximos durante la tarde y disminuir durante la noche.*

*-Considera temperaturas generalmente mayores en verano que en invierno.*

*-Evita patrones perfectamente repetitivos entre días.*


***Humedad relativa***

*-Los valores deben mantenerse entre 35,8 y 99,99%.*

*-La humedad relativa debe presentar una relación generalmente inversa con la temperatura.*

*-Considera mayores valores durante la noche y madrugada.*

*-Incorpora eventos de niebla o nubosidad costera, durante los cuales la humedad relativa puede aproximarse al 99,99%.*



***3. Datos ambientales fuera del invernadero (envir-outside)***

*-Los datos exteriores deben estar relacionados con los registros interiores, manteniendo coherencia temporal entre ambas hojas.*


***Radiación solar***

*-Durante la noche, la radiación debe mantenerse en 0,6 µmol m⁻² s⁻¹.*

*-El valor máximo permitido es 1236,8 µmol m⁻² s⁻¹.*

*-Considera variaciones diarias y estacionales.*

*-Incorpora reducciones de radiación asociadas a nubosidad y niebla.*


***Temperatura***

*-Los valores deben representar condiciones ambientales exteriores de Iquique.*

*-Mantén una variación diaria coherente con los ciclos de radiación solar.*

*-Considera las diferencias de temperatura entre el interior y el exterior del invernadero.*


***Humedad relativa***

*-Los valores deben mantenerse entre 31,8 y 99,99%.*

*-Durante los eventos de niebla, la humedad relativa debe alcanzar exactamente 99,99%.*

*-Considera valores generalmente mayores durante la noche y madrugada.*



***4. Coherencia de los datos***

*-Los datos deben representar condiciones ambientales plausibles de una zona costera árida.*

*-Debe existir variabilidad entre días, semanas y meses.*

*-Evita curvas perfectamente simétricas o patrones artificialmente repetitivos.*

*-Los eventos de niebla deben afectar de manera coherente la radiación solar, la temperatura y la humedad relativa.*

*-Los registros interiores y exteriores deben corresponder a las mismas fechas y horas.*



***5. Entrega de los datos***

*Debido al gran número de registros, genera una planilla Excel por mes, comenzando con mayo de 2026 y terminando con febrero de 2027.*

*Cada planilla debe contener las hojas correspondientes a los datos interiores y exteriores, conservando los encabezados establecidos y la numeración consecutiva de los registros entre meses.*
