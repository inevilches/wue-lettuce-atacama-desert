library(readxl)
library(tidyverse)

niebla <- read_excel(
  "data/data-bibliografia/data-bibliografia-niebla.xlsx"
)

names(niebla) <- c(
  "mes",
  "alto_patache",
  "error_alto_patache",
  "falda_verde",
  "error_falda_verde"
)

niebla$mes <- factor(
  niebla$mes,
  levels = c(
    "Enero", "Febrero", "Marzo", "Abril",
    "Mayo", "Junio", "Julio", "Agosto",
    "Septiembre", "Octubre", "Noviembre", "Diciembre"
  )
)


niebla_largo <- bind_rows(
  niebla %>%
    transmute(
      mes,
      localidad = "Alto Patache",
      promedio = alto_patache,
      error = error_alto_patache
    ),

  niebla %>%
    transmute(
      mes,
      localidad = "Falda Verde",
      promedio = falda_verde,
      error = error_falda_verde
    )
)


View(niebla_largo)


grafico_niebla_comparativo <- ggplot(
  niebla_largo,
  aes(x = mes, y = promedio, fill = localidad)
) +
  geom_col(
    position = position_dodge(width = 0.8),
    color = "black",
    width = 0.7
  ) +
  geom_errorbar(
    aes(
      ymin = pmax(0, promedio - error),
      ymax = promedio + error
    ),
    position = position_dodge(width = 0.8),
    width = 0.2
  ) +
  scale_fill_manual(
    values = c(
      "Alto Patache" = "#477D91",
      "Falda Verde" = "#77936B"
    )
  ) +
  scale_y_continuous(
    breaks = seq(0, 10, 2),
    expand = expansion(mult = c(0, 0.05))
  ) +
  labs(
    title = "Captación diaria de agua de niebla por localidad",
    x = "Mes",
    y = expression("Captación promedio (L " * m^{-2} * " " * day^{-1} * ")"),
    fill = "Localidad"
  ) +
  theme_classic() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1),
    axis.title = element_text(face = "bold"),
    plot.title = element_text(
      face = "bold",
      size = 14,
      hjust = 0.5
    ),
    legend.position = "bottom"
  )

grafico_niebla_comparativo

ggsave(
  filename = "plot/02-grafico-niebla-comparativo.png",
  plot = grafico_niebla_comparativo,
  width = 10,
  height = 6,
  units = "in",
  dpi = 300
)

ggsave(
  filename = "manuscrito/02-grafico-niebla-comparativo.pdf",
  plot = grafico_niebla_comparativo,
  width = 10,
  height = 6,
  units = "in"
)
