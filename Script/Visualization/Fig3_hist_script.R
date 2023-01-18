#===============================================================================
#===============================================================================
# Library.......................................................................
library(here)
library(ggplot2)
library(ggdist)
library(extrafont)
library(scales)
library(ggtext)
library(prismatic)
library(sdamr)
library(readxl)
library(dendextend)
library(svglite)
library(introdataviz)
library(RColorBrewer)
#===============================================================================
setwd(here())
#...............................................................................
#...............................................................................
data_net = read_excel(here("Data", "994participants_gradients_network.xlsx"))
data_net = data_net[data_net$Side=="Asym",]
data_net$Network_7Yeo <- factor(data_net$Network_7Yeo,
                                levels = unique(data_net$Network_7Yeo)[c(7,6,3,
                                                                         5,4,1,2)])
                                # levels = unique(data_net$Network_7Yeo)[c(2, 1, 4,
                                #                                          5, 3, 6, 7)])
dim(data_net)
head(data_net)
pal_col_Yeo = c("#781286", ## violet
                "#4682b4", ## turquoise
                "#00760e", ## green
                "#c43afa", ## pink
                "#dcf8a4", ## white
                "#e69422", ## orange
                "#cd3e4f") ## red
# pal_col_Yeo = pal_col_Yeo[c(7, 6, 5, 4, 3, 2, 1)]
pal_col_Yeo = pal_col_Yeo[c(1,2,3,4,5,6,7)]
pal_col_binaire = rep(c("#159090", ## blue
                        brewer.pal(n = 4, ## pink
                                   name = "Dark2")[4]), 7)
# 1st gradient..................................................................
# limits_plot = abs(c(round(min(data_net[data_net$Gradient_nb=="G1",]$Gradient_Std)), 
#                     round(max(data_net[data_net$Gradient_nb=="G1",]$Gradient_Std))))
limits_plot = c(25)
fig_G1_Yeo_binaire = ggplot(data_net[data_net$Gradient_nb=="G1",], 
                            aes(x = Network_7Yeo,
                                y = Gradient_Std)) + 
  geom_hline(yintercept=0,
             linetype=1,
             size=0.5,
             color='black', alpha=0.3) +
  ggdist::stat_halfeye(adjust = .5,
                       width = .6,
                       .width = 0,
                       point_colour = NA,
                       justification = -.4, 
                       aes(colour = paste(Network_7Yeo,
                                          `Cluster - MMHC binaire (category)`),
                           fill=after_scale(clr_alpha(colour, 0.8)))) + 
  geom_boxplot(width = .3, 
               size=0.5,
               outlier.shape = NA,
               aes(colour=paste(Network_7Yeo,
                                `Cluster - MMHC binaire (category)`),
                   fill=after_scale(clr_lighten(colour, 
                                                space="combined",
                                                shift = 0.755))),
               position = position_dodge2(padding = 0.15)) +
  annotate(geom = "rect",
           xmin = seq(0.8, 7, 1), xmax = seq(1.79, 8, 1),
           ymin = rep(-max(limits_plot)-8, 7), ymax = rep(-max(limits_plot)+2.5-8, 7),
           fill = pal_col_Yeo,
           alpha = 1) + # 0.2
  theme_classic() + 
  theme(plot.title = element_blank(),
        text = element_text(family="Arial"),
        axis.text.x=element_blank(),
        panel.grid = element_line(size = 0.5),
        panel.grid.major.y = element_line(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.line.y = element_blank(),
        axis.line.x = element_blank(),
        axis.text = element_text(face = "plain",
                                 color = "black",
                                 size = 16),
        axis.text.y=element_blank(),
        axis.ticks.x = element_line(size=0),
        axis.ticks.y = element_blank(),
        legend.position = "none") + 
  scale_y_continuous(breaks = scales::pretty_breaks(n = 5),
                     limits = c(-max(limits_plot)-8,
                                max(limits_plot)+5)) +
  scale_color_manual(values=pal_col_binaire) +
  scale_fill_manual(values=pal_col_binaire)
fig_G1_Yeo_binaire

# ggsave(file="fig_Distribution_G1_Yeo_V2.svg", 
#        plot=fig_G1_Yeo_binaire,
#        width = 5.7, height = 3.8,
#        units = "in",
#        dpi = 1200)
# 2sd gradient..................................................................
fig_G2_Yeo_binaire = ggplot(data_net[data_net$Gradient_nb=="G2",], 
                            aes(x = Network_7Yeo,
                                y = Gradient_Std)) + 
  geom_hline(yintercept=0,
             linetype=1,
             size=0.5,
             color='black', alpha=0.3) +
  ggdist::stat_halfeye(adjust = .5,
                       width = .6,
                       .width = 0,
                       point_colour = NA,
                       justification = -.4, 
                       aes(colour = paste(Network_7Yeo,
                                          `Cluster - MMHC binaire (category)`),
                           fill=after_scale(clr_alpha(colour, 0.8)))) + 
  geom_boxplot(width = .3, 
               size=0.5,
               outlier.shape = NA,
               aes(colour=paste(Network_7Yeo,
                                `Cluster - MMHC binaire (category)`),
                   fill=after_scale(clr_lighten(colour, 
                                                space="combined",
                                                shift = 0.755))),
               position = position_dodge2(padding = 0.15)) +
  annotate(geom = "rect",
           xmin = seq(0.8, 7, 1), xmax = seq(1.79, 8, 1),
           ymin = rep(-max(limits_plot)-8, 7), ymax = rep(-max(limits_plot)+2.5-8, 7),
           fill = pal_col_Yeo,
           alpha = 1) + # 0.2
  theme_classic() + 
  theme(plot.title = element_blank(),
        text = element_text(family="Arial"),
        axis.text.x=element_blank(),
        panel.grid = element_line(size = 0.5),
        panel.grid.major.y = element_line(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.line.y = element_blank(),
        axis.line.x = element_blank(),
        axis.text = element_text(face = "plain",
                                 color = "black",
                                 size = 16),
        axis.text.y=element_blank(),
        axis.ticks.x = element_line(size=0),
        axis.ticks.y = element_blank(),
        legend.position = "none") + 
  scale_y_continuous(breaks = scales::pretty_breaks(n = 5),
                     limits = c(-max(limits_plot)-8,
                                max(limits_plot)+5)) +
  scale_color_manual(values=pal_col_binaire) +
  scale_fill_manual(values=pal_col_binaire)
fig_G2_Yeo_binaire

# ggsave(file="fig_Distribution_G2_Yeo_V2.svg", 
#        plot=fig_G2_Yeo_binaire,
#        width = 5.7, height = 3.8,
#        units = "in",
#        dpi = 1200)
# 3th gradient..................................................................
fig_G3_Yeo_binaire = ggplot(data_net[data_net$Gradient_nb=="G3",], 
                            aes(x = Network_7Yeo,
                                y = Gradient_Std)) + 
  geom_hline(yintercept=0,
             linetype=1,
             size=0.5,
             color='black', alpha=0.3) +
  ggdist::stat_halfeye(adjust = .5,
                       width = .6,
                       .width = 0,
                       point_colour = NA,
                       justification = -.4, 
                       aes(colour = paste(Network_7Yeo,
                                          `Cluster - MMHC binaire (category)`),
                           fill=after_scale(clr_alpha(colour, 0.8)))) + 
  geom_boxplot(width = .3, 
               size=0.5,
               outlier.shape = NA,
               aes(colour=paste(Network_7Yeo,
                                `Cluster - MMHC binaire (category)`),
                   fill=after_scale(clr_lighten(colour, 
                                                space="combined",
                                                shift = 0.755))),
               position = position_dodge2(padding = 0.15)) +
  annotate(geom = "rect", 
           xmin = seq(0.8, 7, 1), xmax = seq(1.79, 8, 1),
           ymin = rep(-max(limits_plot)-8, 7), ymax = rep(-max(limits_plot)+2.5-8, 7),
           fill = pal_col_Yeo,
           alpha = 1) + # 0.2
  theme_classic() + 
  theme(plot.title = element_blank(),
        text = element_text(family="Arial"),
        axis.text.x=element_blank(),
        panel.grid = element_line(size = 0.5),
        panel.grid.major.y = element_line(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.line.y = element_blank(),
        axis.line.x = element_blank(),
        axis.text = element_text(face = "plain",
                                 color = "black",
                                 size = 16),
        axis.text.y=element_blank(),
        axis.ticks.x = element_line(size=0),
        axis.ticks.y = element_blank(),
        legend.position = "none") + 
  scale_y_continuous(breaks = scales::pretty_breaks(n = 5),
                     limits = c(-max(limits_plot)-8,
                                max(limits_plot)+5)) +
  scale_color_manual(values=pal_col_binaire) +
  scale_fill_manual(values=pal_col_binaire)
fig_G3_Yeo_binaire

# ggsave(file="fig_Distribution_G3_Yeo_V2.svg", 
#        plot=fig_G3_Yeo_binaire,
#        width = 5.7, height = 3.8,
#        # width = 3.17, height = 1.11,
#        units = "in",
#        dpi = 1200)