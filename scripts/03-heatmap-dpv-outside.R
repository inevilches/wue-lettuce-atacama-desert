
#03-heatmap-dpv-outside.R
#Mapa de calor del DPV exterior del invernadero

# 1.Instalar paquete para mapa de calor y cargar librerías

install.packages("legendry")

library(tidyverse)
library(readxl)
library(lubridate)
library(legendry)

# 2.Importar datos

hobo_outside <- read_excel(
  "data/data-raw-hobo-outside.xlsx",
  sheet = "envir-outside"
)

# 3.Diccionario de toda la base de datos

diccionario_outside <- tribble(
  ~variable, ~tipo, ~valores_admitidos, ~admite_na,

  "ID",
  "entero", "1-43776, sin duplicados", FALSE,

  "date_hobo-out_iso",
  "fecha", "2026-05-01 a 2027-02-28", FALSE,

  "time_hobo-out_HHmmss",
  "hora", "00:00:00 a 23:50:00, cada 10 minutos", FALSE,

  "radiation_hobo-out_umol-m2-s1",
  "numérica", "0-2200", FALSE,

  "temperature_hobo-out_C",
  "numérica", "0-50", FALSE,

  "hr_hobo-out_%",
  "numérica", "1-100", FALSE
)

diccionario_outside

view (diccionario_outside)

# 4.Validación de toda la base de datos

# Revisar estructura de datos

glimpse(hobo_outside)

# función de validación

validar_hobo_outside <- function(datos) {

#Para fecha y hora solo verificamos que no haya saltos en la información

  # Fechas sin NA
  fechas_ok <- !anyNA(datos$`date_hobo-out_iso`)

  # Horas sin NA
  time_ok <- !anyNA(datos$`time_hobo-out_HHmmss`)

#Para radiación, temperatura y humedad relativa, validamos los registros del sensor

  # Radiación: entre 0 y 2200
  radiacion_ok <- all(
    datos$`radiation_hobo-out_umol-m2-s1` >= 0 &
      datos$`radiation_hobo-out_umol-m2-s1` <= 2200,
    na.rm = FALSE
  )

  # Temperatura: entre 0 y 50
  temperatura_ok <- all(
    datos$`temperature_hobo-out_C` >= 0 &
      datos$`temperature_hobo-out_C` <= 50,
    na.rm = FALSE
  )

  # Humedad relativa: entre 1 y 100
  hr_ok <- all(
    datos$`hr_hobo-out_%` >= 1 &
      datos$`hr_hobo-out_%` <= 100,
    na.rm = FALSE
  )

  marca <- function(x) ifelse(isTRUE(x), "OK", "FALLA")

  cat("Fechas sin NA (integridad):", marca(fechas_ok), "\n")
  cat("Horas sin NA (integridad):", marca(time_ok), "\n")
  cat("Radiación 0-2200 (contenido):", marca(radiacion_ok), "\n")
  cat("Temperatura 0-50 (contenido):", marca(temperatura_ok), "\n")
  cat("Humedad relativa 1-100 (contenido):", marca(hr_ok), "\n")

}

validar_hobo_outside(hobo_outside)

# Todo OK, dentro de los valores del diccionario

# 5. Cálculo del DPV usando fórmula de DPV con datos de temperatura y humedad relativa

dpv_outside <- hobo_outside %>%
  mutate(
    es = 0.6108 * exp(
      (17.27 * `temperature_hobo-out_C`) /
        (`temperature_hobo-out_C` + 237.3)
    ),
    ea = es * (`hr_hobo-out_%` / 100),
    dpv = es - ea
  )

summary(dpv_outside$dpv)

all(dpv_outside$dpv >= 0, na.rm = FALSE)

# 6. Promedio DPV por mes y hora

dpv_outside_prom_meshora <- dpv_outside %>%
  mutate(
    mes = floor_date(`date_hobo-out_iso`, unit = "month"),
    hora = hour(`time_hobo-out_HHmmss`)
  ) %>%
  group_by(mes, hora) %>%
  summarise(
    dpv_prom = mean(dpv),
    .groups = "drop"
  )

glimpse(dpv_outside_prom_meshora)

# 7. Construcción del mapa de calor (heatmap)

heatmap_dpv_outside <- ggplot(
  dpv_outside_prom_meshora,
  aes(x = factor(mes), y = hora, fill = dpv_prom)
) +
  geom_tile() +
  scale_fill_viridis_c(
    option = "plasma",
    limits = c(0, 3),
    breaks = seq(0, 3, 0.5)
    ) +
  scale_x_discrete(
    labels = c(
      "May", "Jun", "Jul", "Ago",
      "Sep", "Oct", "Nov", "Dic",
      "Ene", "Feb"
    ),
    guide = legendry::guide_axis_nested(
      key = legendry::key_range_manual(
        start = c(1, 9),
        end = c(8, 10),
        name = c("2026", "2027")
      )
    ),
    expand = c(0, 0)
  ) +
  scale_y_continuous(
    breaks = seq(0, 23, 3),
    labels = function(x) sprintf("%02d:00", x),
    expand = c(0, 0)
  ) +
  labs(
    title = "Déficit de presión de vapor exterior invernadero",
    subtitle = "Alto Patache | Mayo 2026 - Febrero 2027",
    x = NULL,
    y = NULL,
    fill = "DPV (kPa)"
  ) +
  theme_minimal() +
  theme(
    panel.grid = element_blank(),
    plot.background = element_rect(
      fill = "white", colour = NA
    )
  )

heatmap_dpv_outside

# 8. Exportación del gráfico

# Guardar en formato PNG
ggsave(
  filename = "plot/03-heatmap-dpv-outside.png",
  plot = heatmap_dpv_outside,
  width = 10,
  height = 7,
  units = "in",
  dpi = 300,
  bg = "white"
)

# Guardar en formato PDF
ggsave(
  filename = "pdf/03-heatmap-dpv-outside.pdf",
  plot = heatmap_dpv_outside,
  width = 10,
  height = 7,
  units = "in",
  bg = "white"
)
