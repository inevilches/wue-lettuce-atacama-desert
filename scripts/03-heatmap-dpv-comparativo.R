
#03-heatmap-dpv-comparativo.R

# 1. Instalar paquete para mapa de calor y cargar librerías

#install.packages("legendry")

library(tidyverse)
library(readxl)
library(lubridate)
library(legendry)

# 2. Importar datos outside e inside

# 2.1 hobo-outside

hobo_outside <- read_excel(
  "data/data-raw-hobo-outside.xlsx",
  sheet = "envir-outside"
)

# 2.2 hobo-inside

hobo_inside <- read_excel(
  "data/data-raw-hobo-inside.xlsx",
  sheet = "envir-inside"
)

#Para DPV exterior del invernadero

# 3.Diccionarios

# 3.1 hobo-outside

diccionario_outside <- tribble(
  ~variable, ~tipo, ~valores_admitidos, ~admite_na,

  "id",
  "entero", "1-43776, sin duplicados", FALSE,

  "date_hobo-out_iso",
  "fecha", "2026-05-01 a 2027-02-28", FALSE,

  "time_hobo-out_hhmmss",
  "hora", "00:00:00 a 23:50:00, cada 10 minutos", FALSE,

  "radiation_hobo-out_umol-m2-s1",
  "numérica", "0-2200", FALSE,

  "temperature_hobo-out_c",
  "numérica", "0-50", FALSE,

  "hr_hobo-out_%",
  "numérica", "1-100", FALSE
)

diccionario_outside

view (diccionario_outside)

# 3.2 hobo-inside

diccionario_inside <- tribble(
  ~variable, ~tipo, ~valores_admitidos, ~admite_na,

  "id",
  "entero", "1-43776, sin duplicados", FALSE,

  "date_hobo-in_iso",
  "fecha", "2026-05-01 a 2027-02-28", FALSE,

  "time_hobo-in_hhmmss",
  "hora", "00:00:00 a 23:50:00, cada 10 minutos", FALSE,

  "radiation_hobo-in_umol-m2-s1",
  "numérica", "0-2200", FALSE,

  "temperature_hobo-in_c",
  "numérica", "0-50", FALSE,

  "hr_hobo-in_%",
  "numérica", "1-100", FALSE
)

diccionario_inside

view (diccionario_inside)

# 4.Validación de los datos

# 4.1 hobo-outside
# Revisar estructura de datos

glimpse(hobo_outside)

# función de validación

validar_hobo_outside <- function(datos) {

  #Para fecha y hora solo verificamos que no haya datos faltantes

  # Fechas sin NA
  fechas_ok <- !anyNA(datos$`date_hobo-out_iso`)

  # Horas sin NA
  time_ok <- !anyNA(datos$`time_hobo-out_hhmmss`)

  #Para radiación, temperatura y humedad relativa, validamos los registros del sensor

  # Radiación: entre 0 y 2200
  radiacion_ok <- all(
    datos$`radiation_hobo-out_umol-m2-s1` >= 0 &
      datos$`radiation_hobo-out_umol-m2-s1` <= 2200,
    na.rm = FALSE
  )

  # Temperatura: entre 0 y 50
  temperatura_ok <- all(
    datos$`temperature_hobo-out_c` >= 0 &
      datos$`temperature_hobo-out_c` <= 50,
    na.rm = FALSE
  )

  # Humedad relativa: entre 1 y 100
  hr_ok <- all(
    datos$`hr_hobo-out_%` >= 1 &
      datos$`hr_hobo-out_%` <= 100,
    na.rm = FALSE
  )

  marca <- function(x) ifelse(isTRUE(x), "OK", "FALLA")

  cat("Fechas sin NA", marca(fechas_ok), "\n")
  cat("Horas sin NA", marca(time_ok), "\n")
  cat("Radiación 0-2200", marca(radiacion_ok), "\n")
  cat("Temperatura 0-50", marca(temperatura_ok), "\n")
  cat("Humedad relativa 1-100", marca(hr_ok), "\n")

}

validar_hobo_outside(hobo_outside)

# Todo OK, dentro de los valores del diccionario

# 4.2 hobo-inside
# Revisar estructura de datos

glimpse(hobo_inside)

# función de validación

validar_hobo_inside <- function(datos) {

  #Para fecha y hora solo verificamos que no haya saltos en la información

  # Fechas sin NA
  fechas_ok <- !anyNA(datos$`date_hobo-in_iso`)

  # Horas sin NA
  time_ok <- !anyNA(datos$`time_hobo-in_hhmmss`)

  #Para radiación, temperatura y humedad relativa, validamos los registros del sensor

  # Radiación: entre 0 y 2200
  radiacion_ok <- all(
    datos$`radiation_hobo-in_umol-m2-s1` >= 0 &
      datos$`radiation_hobo-in_umol-m2-s1` <= 2200,
    na.rm = FALSE
  )

  # Temperatura: entre 0 y 50
  temperatura_ok <- all(
    datos$`temperature_hobo-in_c` >= 0 &
      datos$`temperature_hobo-in_c` <= 50,
    na.rm = FALSE
  )

  # Humedad relativa: entre 1 y 100
  hr_ok <- all(
    datos$`hr_hobo-in_%` >= 1 &
      datos$`hr_hobo-in_%` <= 100,
    na.rm = FALSE
  )

  marca <- function(x) ifelse(isTRUE(x), "OK", "FALLA")

  cat("Fechas sin NA", marca(fechas_ok), "\n")
  cat("Horas sin NA", marca(time_ok), "\n")
  cat("Radiación 0-2200", marca(radiacion_ok), "\n")
  cat("Temperatura 0-50", marca(temperatura_ok), "\n")
  cat("Humedad relativa 1-100", marca(hr_ok), "\n")

}

validar_hobo_inside (hobo_inside)

# Todo OK, dentro de los valores del diccionario

# 5. Cálculo del DPV usando fórmula de DPV con datos de temperatura y humedad relativa

# 5.1 dpv-outside

dpv_outside <- hobo_outside %>%
  mutate(
    es = 0.6108 * exp(
      (17.27 * `temperature_hobo-out_c`) /
        (`temperature_hobo-out_c` + 237.3)
    ),
    ea = es * (`hr_hobo-out_%` / 100),
    dpv = es - ea
  )

summary(dpv_outside$dpv)

all(dpv_outside$dpv >= 0, na.rm = FALSE)

# 5.2 dpv-inside

dpv_inside <- hobo_inside %>%
  mutate(
    es = 0.6108 * exp(
      (17.27 * `temperature_hobo-in_c`) /
        (`temperature_hobo-in_c` + 237.3)
    ),
    ea = es * (`hr_hobo-in_%` / 100),
    dpv = es - ea
  )

summary(dpv_inside$dpv)

all(dpv_inside$dpv >= 0, na.rm = FALSE)

# 6. Promedio DPV por mes y hora

# 6.1 dpv-outside

dpv_outside_prom_meshora <- dpv_outside %>%
  mutate(
    mes = floor_date(`date_hobo-out_iso`, unit = "month"),
    hora = hour(`time_hobo-out_hhmmss`)
  ) %>%
  group_by(mes, hora) %>%
  summarise(
    dpv_prom = mean(dpv),
    .groups = "drop"
  )

glimpse(dpv_outside_prom_meshora)

# 6.2 dpv-inside

dpv_inside_prom_meshora <- dpv_inside %>%
  mutate(
    mes = floor_date(`date_hobo-in_iso`, unit = "month"),
    hora = hour(`time_hobo-in_hhmmss`)
  ) %>%
  group_by(mes, hora) %>%
  summarise(
    dpv_prom = mean(dpv),
    .groups = "drop"
  )

glimpse(dpv_inside_prom_meshora)

# 7. Construcción del mapa de calor comparativo

# 7.1 Unión de los datos de DPV interior y exterior

dpv_comparativo <- bind_rows(
  dpv_outside_prom_meshora %>%
    mutate(ambiente = "exterior"),

  dpv_inside_prom_meshora %>%
    mutate(ambiente = "interior")
)

glimpse(dpv_comparativo)

view(dpv_comparativo)

# 7.2 Orden de los ambientes

dpv_comparativo <- dpv_comparativo %>%
  mutate(
    ambiente = factor(
      ambiente,
      levels = c("exterior", "interior")
    )
  )

count(dpv_comparativo, ambiente)

range(dpv_comparativo$dpv_prom)

# 7.3 Construcción del mapa de calor comparativo

# Tratamientos

tratamientos <- tibble(
  ambiente = "exterior",
  inicio = c(0.6, 2.6, 6.6, 8.6),
  fin = c(2.4, 4.4, 8.4, 10.4),
  centro = c(1.5, 3.5, 7.5, 9.5),
  tratamiento = c("T1", "T2", "T1", "T2"),
  color = c("#0072B2", "#E69F00",
            "#0072B2", "#E69F00")
)

# Temporadas

temporadas <- tibble(
  ambiente = "exterior",
  centro = c(2.5, 8.5),
  temporada = c("Invierno", "Verano")
)

# 7.4. Construcción del mapa de calor comparativo

heatmap_dpv_comparativo <- ggplot(
  dpv_comparativo,
  aes(
    x = factor(mes),
    y = hora,
    fill = dpv_prom
  )
) +

  geom_tile() +

  # Líneas de los tratamientos
  geom_segment(
    data = tratamientos,
    aes(
      x = inicio,
      xend = fin,
      y = 24.2,
      yend = 24.2,
      colour = color
    ),
    inherit.aes = FALSE,
    linewidth = 1
  ) +

  # Etiquetas de los tratamientos
  geom_text(
    data = tratamientos,
    aes(
      x = centro,
      y = 25.8,
      label = tratamiento,
      colour = color
    ),
    inherit.aes = FALSE,
    size = 3
  ) +

  # Etiquetas de las temporadas
  geom_text(
    data = temporadas,
    aes(
      x = centro,
      y = 28,
      label = temporada
    ),
    inherit.aes = FALSE,
    fontface = "bold",
    size = 3
  ) +

  # Colores de los tratamientos
  scale_colour_identity() +

  # Separación de los ambientes
  facet_wrap(
    ~ ambiente,
    ncol = 1,
    scales = "free_y",
    space = "free_y",
    labeller = as_labeller(
      c(
        exterior = "Exterior",
        interior = "Interior"
      )
    )
  ) +

  # Escala de colores del DPV
  scale_fill_viridis_c(
    option = "plasma",
    limits = c(0, 5),
    breaks = seq(0, 5, 0.5)
  ) +

  # Formato del eje Y
  scale_y_continuous(
    breaks = seq(0, 23, 3),
    labels = function(x) sprintf("%02d:00", x),
    expand = expansion(add = c(0, 1.5))
  ) +

  # Formato del eje X
  scale_x_discrete(
    labels = c(
      "May\n2026", "Jun\n2026", "Jul\n2026",
      "Ago\n2026", "Sep\n2026", "Oct\n2026",
      "Nov\n2026", "Dic\n2026", "Ene\n2027",
      "Feb\n2027"
    ),
    guide = legendry::guide_axis_nested(),
    expand = c(0, 0)
  ) +

  # Títulos y etiquetas
  labs(
    title = "Déficit de Presión de Vapor - Alto Patache",
    subtitle = "Exterior v/s Interior invernadero | Mayo 2026 - Febrero 2027",
    x = NULL,
    y = NULL,
    fill = "DPV (kPa)"
  ) +

  # Estética del gráfico
  theme_minimal() +
  theme(
    panel.grid = element_blank(),
    strip.text = element_text(
      face = "bold",
      size = 10
    ),
    panel.spacing = unit(0.4, "cm"),
    legend.key.height = unit(0.7, "cm")
  )

heatmap_dpv_comparativo

# 8. Exportación del gráfico comparativo

# Guardar en formato PNG

ggsave(
  filename = "plot/03-heatmap-dpv-comparativo.png",
  plot = heatmap_dpv_comparativo,
  width = 10,
  height = 9,
  units = "in",
  dpi = 300,
  bg = "white"
)

# Guardar en formato PDF

ggsave(
  filename = "pdf/03-heatmap-dpv-comparativo.pdf",
  plot = heatmap_dpv_comparativo,
  width = 10,
  height = 9,
  units = "in",
  bg = "white"
)
