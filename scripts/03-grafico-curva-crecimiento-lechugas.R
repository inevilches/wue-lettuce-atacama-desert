library(readxl)
library(tidyverse)

lechuga <- read_excel(
  "data/data-raw/data-raw-lechugas.xlsx",
  sheet = "lettuce"
)

View(lechuga)
names(lechuga)


#Promedio de las 8 piscinas dentro de cada repetición:

promedio_rep <- lechuga %>%
  group_by(season, treatment, rep, `date-dat`) %>%
  summarise(
    peso_promedio = mean(`fresh-weight_leaves_g`, na.rm = TRUE),
    .groups = "drop"
  )

promedio_crecimiento <- promedio_rep %>%
  group_by(season, treatment, `date-dat`) %>%
  summarise(
    desviacion = sd(peso_promedio, na.rm = TRUE),
    n = sum(!is.na(peso_promedio)),
    media = mean(peso_promedio, na.rm = TRUE),
    .groups = "drop"
  ) %>%
  mutate(
    peso_promedio = media,
    error_estandar = desviacion / sqrt(n)
  )

#Construcción curva de crecimiento:

grafico_crecimiento <- ggplot(
  promedio_crecimiento,
  aes(
    x = `date-dat`,
    y = peso_promedio,
    color = factor(treatment),
    group = treatment
  )
) +
  geom_ribbon(
    aes(
      ymin = peso_promedio - error_estandar,
      ymax = peso_promedio + error_estandar,
      fill = factor(treatment)
    ),
    alpha = 0.15,
    color = NA
  ) +
  geom_line(linewidth = 1) +
  geom_point(size = 1.8) +
  facet_wrap(~season) +
  scale_color_manual(
    values = c(
      "1" = "#55A9D2",
      "2" = "#66B69B"
    )
  ) +
  scale_fill_manual(
    values = c(
      "1" = "#55A9D2",
      "2" = "#66B69B"
    ),
    guide = "none"
  ) +
  scale_x_continuous(
    breaks = seq(0, 28, 4)
  ) +
  labs(
    title = "Curva de crecimiento de lechugas",
    x = "Días después del trasplante (DAT)",
    y = "Peso fresco promedio de hojas (g)",
    color = "Tratamiento"
  ) +
  theme_classic() +
  theme(
    plot.title = element_text(
      face = "bold",
      hjust = 0.5
    ),
    axis.title = element_text(face = "bold"),
    legend.position = "bottom"
  )

grafico_crecimiento



ggsave(
  filename = "plot/03-curva-crecimiento-lechugas.png",
  plot = grafico_crecimiento,
  width = 10,
  height = 6,
  units = "in",
  dpi = 300
)


ggsave(
  filename = "manuscrito/03-curva-crecimiento-lechugas.pdf",
  plot = grafico_crecimiento,
  width = 10,
  height = 6,
  units = "in"
)




