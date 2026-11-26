
#Creación de un mapa de las localidades de estudio del Fondecyt 13220028

# Instalar paquetes para crear mapa y personalizarlo + cargar librerias

install.packages(c("sf", "rnaturalearth",
                   "rnaturalearthdata", "ggimage", "pak", "ggrepel", "ggspatial", "patchwork"))

install.packages(
  "rnaturalearthhires",
  repos = c(
    "https://ropensci.r-universe.dev",
    "https://cloud.r-project.org"
  ),
  type = "binary"
)

library(tidyverse)
library(sf)
library(rnaturalearth)
library(ggrepel)
library(ggimage)
library(ggspatial)
library(patchwork)

# Tabla ubicaciones localidades

sites <- tribble(
  ~location,       ~longitude, ~latitude,   ~altitude, ~type,
  "Iquique",       -70.152000,  -20.214000,  1,  "City",
  "Alto Patache",  -70.150000,  -20.816667,  850,       "Research site",
  "Antofagasta",   -70.400000, -23.650000,    40,  "City",
  "Falda Verde",   -70.600000,  -26.283333,  600,       "Research site",
  "Copiapó",       -70.333000, -27.366000,   383,  "City"
)

# Crear mapa principal: límites geográficos

paises <- ne_countries(
  scale = "medium",
  returnclass = "sf"
)

regiones <- ne_states(
  country = "Chile",
  returnclass = "sf"
)

# Crear mapa principal: mapa grande con localidades

mapa_principal <- ggplot() +
  geom_sf(
    data = regiones,
    fill = "#EDE3D3",
    color = "grey60"
  ) +
  geom_image(
    data = filter(sites, type == "Research site"),
    aes(x = longitude, y = latitude),
    image = "images/05-icono-invernadero.png",
    size = 0.06
  ) +
  theme_minimal() +
  geom_point(
    data = filter(sites, type == "City"),
    aes(x = longitude, y = latitude),
    color = "red",
    size = 2,
    shape = 16
  ) +
  geom_text_repel(
    data = sites,
    aes(
      x = longitude,
      y = latitude,
      label = location
    ),
    size = 3,
    color = "grey20",
    box.padding = 0.5,
    point.padding = 0.5,
    max.overlaps = Inf,
    seed = 123
  ) +
  scale_x_continuous(
    breaks = c(-72, -70, -68),
    minor_breaks = NULL
  ) +
  scale_y_continuous(
    breaks = c(-20, -22, -24, -26),
    minor_breaks = NULL
  ) +
  annotation_north_arrow(
    location = "tl",
    which_north = "true",
    style = north_arrow_fancy_orienteering,
    height = unit(1, "cm"),
    width = unit(1, "cm")
  ) +
  annotation_scale(
    location = "bl",
    width_hint = 0.3,
    text_cex = 0.7,
    unit_category = "metric"
  ) +
  coord_sf(
    xlim = c(-74, -67),
    ylim = c(-28, -18),
    expand = FALSE
  ) +
  labs(
    title = NULL,
    x = NULL,
    y = NULL,
    color = NULL
  ) +
  guides(size = "none") +
  theme_minimal() +
  theme(
    panel.background = element_rect(
      fill = "#E4EFF4"
    ),
    legend.position = "bottom",
    axis.text = element_text(size = 9),
    panel.grid.major = element_line(
      color = "grey85",
      linewidth = 0.3
    ),
    panel.grid.minor = element_blank()
  )

mapa_principal

# Crear mapa pequeño: mapa de Chile

mapa_chile <- ggplot() +
  geom_sf(
    data = regiones,
    fill = "#EDE3D3",
    color = "grey60",
    linewidth = 0.2
  ) +
  annotate(
    "rect",
    xmin = -74,
    xmax = -67,
    ymin = -28,
    ymax = -18,
    fill = NA,
    color = "red",
    linewidth = 0.8
  ) +
  coord_sf(
    xlim = c(-76, -66),
    ylim = c(-56, -17),
    expand = FALSE
  ) +
  theme_void() +
  theme(
    panel.background = element_rect(
      fill = "#F5F5F5"
    ),
    panel.border = element_rect(
      color = "grey40",
      fill = NA,
      linewidth = 0.5
    )
  )

mapa_chile

# Superponer ambos mapas: mapa final

mapa_final <- mapa_principal +
  inset_element(
    mapa_chile,
    left = 0.72,
    bottom = 0.55,
    right = 0.98,
    top = 0.98,
    align_to = "panel"
  )

mapa_final

# Guardar el mapa final en .png

ggsave(
  filename = "plot/01-mapa-lugares-estudio.png",
  plot = mapa_final,
  width = 5,
  height = 7,
  units = "in",
  dpi = 300,
  bg = "white"
)

# Guardar el mapa final en .pdf

ggsave(
  filename = "pdf/01-mapa-lugares-estudio.pdf",
  plot = mapa_final,
  width = 5,
  height = 7,
  units = "in",
  bg = "white"
)
