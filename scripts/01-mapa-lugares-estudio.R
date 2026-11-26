
#Creación de un mapa de las localidades de estudio del Fondecyt 13220028

# Instalar paquetes para crear mapa y personalizarlo

install.packages(c("sf", "rnaturalearth",
                   "rnaturalearthdata", "ggimage", "ggrepel"))


library(tidyverse)
library(sf)
library(rnaturalearth)
library(ggrepel)
library(ggimage)

# Tabla ubicaciones localidades

sites <- tribble(
  ~location,       ~longitude, ~latitude,   ~altitude, ~type,
  "Iquique",       -70.152000,  -20.214000,  1,  "City",
  "Alto Patache",  -70.150000,  -20.816667,  850,       "Research site",
  "Falda Verde",   -70.600000,  -26.283333,  600,       "Research site",
  "Chañaral",      -70.622000,  -26.347000,  198,  "City"
)

# Crear mapa: límites países

world <- ne_countries(
  scale = "medium",
  returnclass = "sf"
)

# Crear mapa: figura

ggplot() +
  geom_sf(
    data = world,
    fill = "#EDE3D3",
    color = "grey60"
  ) +
  geom_point(
    data = filter(sites, type == "City"),
    aes(x = longitude, y = latitude),
    color = "grey40",
    size = 2
  ) +
 geom_text(
  data = filter(sites, type == "Research site"),
  aes(x = longitude, y = latitude),
  label = "🏠",
  size = 6
) +
  scale_color_manual(
    values = c(
      "City" = "grey40",
      "Research site" = "#478B70"
    )
  ) +
  scale_size_manual(
    values = c(
      "City" = 2,
      "Research site" = 4
    )
  ) +
  coord_sf(
    xlim = c(-74, -67),
    ylim = c(-28, -18),
    expand = FALSE
  ) +
  labs(
    title = "Research sites",
    subtitle = "Coastal Atacama Desert, Chile",
    color = NULL
  ) +
  guides(size = "none") +
  theme_minimal() +
  theme(
    panel.background = element_rect(
      fill = "#E4EFF4"
    ),
    legend.position = "bottom"
  )
