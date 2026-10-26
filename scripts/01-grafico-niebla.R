#Gráfico de los l/m2 malla capturados desde la niebla en Alto Patache y Falda Verde

library(readxl)
library(tidyverse)

niebla <- read_excel("data/data-bibliografia/data-bibliografia-niebla.xlsx")

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


#Grafico Alto Patache

grafico_alto_patache <- ggplot(niebla, aes(x = mes, y = alto_patache)) +
  geom_col(fill = "#477D91", color = "black", width = 0.35) +
  geom_errorbar(
    aes(ymin = alto_patache - error_alto_patache,
        ymax = alto_patache + error_alto_patache),
    width = 0.15
  ) +
  scale_y_continuous(
    limits = c(0, 10),
    breaks = seq(0, 10, 2)
  ) +
  labs(
    x = "Month",
    y = expression("Average yield (L " * m^{-2} * " " * day^{-1} * ")"),
    title = "Alto Patache"
  ) +
  theme_classic() +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    axis.text.x = element_text(angle = 45, hjust = 1),
    axis.title = element_text(face = "bold")
  )


#Grafico Falda Verde

grafico_falda_verde <- ggplot(niebla, aes(x = mes, y = falda_verde)) +
  geom_col(fill = "#77936B", color = "black", width = 0.35) +
  geom_errorbar(
    aes(ymin = falda_verde - error_falda_verde,
        ymax = falda_verde + error_falda_verde),
    width = 0.15
  ) +
  scale_y_continuous(
    limits = c(0, 10),
    breaks = seq(0, 10, 2)
  ) +
  labs(
    x = "Month",
    y = expression("Average yield (L " * m^{-2} * " " * day^{-1} * ")"),
    title = "Falda Verde"
  ) +
  theme_classic() +
  theme(
    plot.title = element_text(face = "bold", size = 16),
    axis.text.x = element_text(angle = 45, hjust = 1),
    axis.title = element_text(face = "bold")
  )


#Unión de los gráficos

library(patchwork)

grafico_niebla <- grafico_alto_patache / grafico_falda_verde

print(grafico_niebla)

#Guardar gráfico en .png

ggsave(
  filename = "plot/01-grafico-niebla.png",
  plot = grafico_niebla,
  width = 9,
  height = 10,
  units = "in",
  dpi = 300
)

#Guardar gráfico en .pdf

ggsave(
  filename = "manuscrito/01-grafico-niebla.pdf",
  plot = grafico_niebla,
  width = 9,
  height = 10
)
