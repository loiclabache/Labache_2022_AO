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
library(RColorBrewer)
#===============================================================================
setwd(here())
#===============================================================================
#===============================================================================
# Rain Cloud Plot...............................................................
data = read_excel(here("Data", "995participants_language_metrics_HCP.xlsx"))
dim(data)
head(data)

summary(data$STORYminusMath_SentCore_Asym)
summary(data$DC_Asym)

pal_col = c("#159090", ## blue
            "#9f34f0", ## violet
            "#ff8c00") ## orange
#...............................................................................
#...............................................................................

fig_Task_asym = ggplot(data, 
                       aes(x = `Cluster - MMHC (category)`,
                           y = STORYminusMath_SentCore_Asym)) + 
  ## add horizontal line at zero
  geom_hline(yintercept=0,
             linetype=1, # linetype=3 for small dotted line, 1 for straight line
             size=0.5,
             color='black', alpha=0.3) +
  ## add half-violin from {ggdist} package
  ggdist::stat_halfeye(
    # custom bandwidth
    adjust = .5,
    ## adjust height
    width = .6,
    ## 0 for remove slab interval
    ## 1 will add a line all along the violin plot
    .width = 0,
    ## move geom to the middle
    # justification = -0.3,
    ## or use position: 
    # position = position_nudge(x = 0.2),
    point_colour = NA,
    # alpha=0.8,
    aes(colour = `Cluster - MMHC (category)`,
        fill=after_scale(clr_lighten(colour, 
                                     space="combined")))
    ) + 
  
  geom_linerange(aes(ymin = -1.14, 
                     ymax = -0.78, 
                      x = 1), ## position
                 color = pal_col[1],
                 size = 0.5) +
  # geom_point(aes(x=1, y=-0.96), 
  #            size=1,
  #            shape=4,
  #            colour=pal_col[1]) +
  geom_linerange(aes(ymin = 0.58,
                     ymax = 0.82,
                     x = 2), ## position
                 color = pal_col[2],
                 size = 0.5) +
  # geom_point(aes(x=2, y=0.7), 
  #            size=1,
  #            shape=4,
  #            colour=pal_col[2]) +
  geom_linerange(aes(ymin = 1.6, 
                     ymax = 1.88, 
                     x = 3), ## position
                 color = pal_col[3],
                 size = 0.5) +
  # geom_point(aes(x=3, y=1.74), 
  #            size=1,
  #            shape=4,
  #            colour=pal_col[3]) +
  
  geom_boxplot(
    width = .25, 
    size=0.5,
    ## remove outliers
    outlier.shape = NA,
    aes(colour=`Cluster - MMHC (category)`,
        fill=after_scale(clr_lighten(colour, 
                                     space="combined",
                                     shift = 0.755))),
    position = position_nudge(x = -0.2)
  ) +
  ## trick to have transparency for dot but not transparency on background
  geom_point(
    shape=21,
    size = 0.5,
    stroke = 0.25,
    colour = "white", fill = "white",
    position = position_jitternudge(jitter.width = .15,
                                    nudge.x = -0.2,
                                    seed = 1)
  ) +
  ##
  geom_point(
    shape=21,
    size = 0.5, #1.3 | 3
    stroke = 0.25, # size of external circle
    # alpha=0.9,
    aes(colour=`Cluster - MMHC (category)`, 
        fill=after_scale(clr_alpha(colour, 0.4))),
    # position = position_nudge(x = -0.2),
    position = position_jitternudge(jitter.width = .15,
                                    nudge.x = -0.2,
                                    seed = 1)
  ) + 
  theme_classic() + 
  theme(plot.title = element_blank(),
        text = element_text(family="Arial"),
        # axis.text.x = element_text(color="grey33"),
        ## make disappear the text of the x axis
        axis.text.x=element_blank(),
        panel.grid = element_line(size = 0.5),
        panel.grid.major.x = element_line(),
        ## add y line:
        # panel.grid.major.y = element_line(colour = pal_col,
        #                                   size = 1,
        #                                   linetype = 2),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        ## make disappear axis lines
        axis.line.y = element_blank(),
        axis.line.x = element_blank(),
        axis.text = element_text(face = "plain", # bold
                                 color = "black",
                                 size = 16),
        # axis.text.y = ggtext::element_markdown(colour=pal_col),
        ## make disappear the text of the y axis
        axis.text.y=element_blank(),
        ## ticks thickness: make disappear ticks
        axis.ticks.x = element_line(size=0), # 1
        ## ticks height
        # axis.ticks.length.x=unit(.25, "cm"),
        axis.ticks.y = element_blank(),
        legend.position = "none") + 
  ## legend of x axis
  # scale_x_discrete(labels=c("ATYP","TYP_mild","TYP_strong")) +
  scale_x_discrete(labels=c("","","")) +
  ## increase number of tick on y axis
  scale_y_continuous(breaks = scales::pretty_breaks(n = 10)) + # or n=5
  ## specify group color
  scale_color_manual(values=pal_col) +
  scale_fill_manual(values=pal_col)  +
  ## make the plot horizontal 
  ## and remove white space on the bottom
  coord_flip(xlim = c(1.2, NA),
             ylim = c(-4, 5),
             clip = "off")
fig_Task_asym

#...............................................................................
#...............................................................................
summary(data$DC_Asym)
fig_DC_asym = ggplot(data, 
                     aes(x = `Cluster - MMHC (category)`,
                         y = DC_Asym)) + 
  geom_hline(yintercept=0,
             linetype=1,
             size=0.5,
             color='black', alpha=0.3) +
  ggdist::stat_halfeye(adjust = .5,
                       width = .6,
                       .width = 0,
                       point_colour = NA,
                       aes(colour = `Cluster - MMHC (category)`,
                           fill=after_scale(clr_lighten(colour, 
                                                        space="combined")))) + 
  geom_linerange(aes(ymin = -0.171, 
                     ymax = 0.189, 
                     x = 1), ## position
                 color = pal_col[1],
                 size = 0.5) +
  geom_linerange(aes(ymin = 0.73,
                     ymax = 0.97,
                     x = 2), ## position
                 color = pal_col[2],
                 size = 0.5) +
  geom_linerange(aes(ymin = 0.89, 
                     ymax = 1.15, 
                     x = 3), ## position
                 color = pal_col[3],
                 size = 0.5) +
  geom_boxplot(width = .25, 
               size=0.5,
               outlier.shape = NA,
               aes(colour=`Cluster - MMHC (category)`,
                   fill=after_scale(clr_lighten(colour, 
                                                space="combined",
                                                shift = 0.755))),
               position = position_nudge(x = -0.2)) +
  geom_point(shape=21,
             size = 0.5,
             stroke = 0.25,
             colour = "white", fill = "white",
             position = position_jitternudge(jitter.width = .15,
                                             nudge.x = -0.2,
                                             seed = 1)) +
  geom_point(shape=21,
             size = 0.5,
             stroke = 0.25,
             aes(colour=`Cluster - MMHC (category)`, 
                 fill=after_scale(clr_alpha(colour, 0.4))),
             position = position_jitternudge(jitter.width = .15,
                                             nudge.x = -0.2,
                                             seed = 1)) + 
  theme_classic() + 
  theme(plot.title = element_blank(),
        text = element_text(family="Arial"),
        # axis.text.x = element_text(color="grey33"),
        ## make disappear the text of the x axis
        axis.text.x=element_blank(),
        panel.grid = element_line(size = 0.5),
        panel.grid.major.x = element_line(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.line.y = element_blank(),
        axis.line.x = element_blank(),
        axis.text = element_text(face = "plain",
                                 color = "black",
                                 size = 16),
        # axis.text.y = ggtext::element_markdown(colour=pal_col),
        ## make disappear the text of the y axis
        axis.text.y=element_blank(),
        axis.ticks.x = element_line(size=0),
        axis.ticks.y = element_blank(),
        legend.position = "none") + 
  scale_x_discrete(labels=c("","","")) +
  scale_y_continuous(breaks = scales::pretty_breaks(n = 10)) + # or n=5
  scale_color_manual(values=pal_col) +
  scale_fill_manual(values=pal_col)  +
  coord_flip(xlim = c(1.2, NA),
             ylim = c(-3, 4),
             clip = "off")
fig_DC_asym

#...............................................................................
#...............................................................................

h <- hclust(dist(scale(data[,c(4,7,10,11,12)]),
                 method = "euclidean"),
            method = "ward.D2")
table(cutree(h, 3))
## prepare dendrogram object
h_dend = as.dendrogram(h) %>%
  color_branches(k = 3) %>%
  set("labels", rep('', dim(data)[1])) %>%
  set("labels_cex", 0) %>%
  set("branches_lwd", 0.5) %>%
  set("branches_k_color", value = pal_col[c(3,1,2)], k = 3) %>%
  rotate(c(562:481, 563:995, 1:480)) 
## transform the object into a ggplot2 object
h_dend_gg <- as.ggdend(h_dend)
fig_CAH = ggplot(h_dend_gg, labels = FALSE, horiz = F) + # F or T 
  theme_void() + 
  geom_rect(aes(xmin = c(1,83,516), xmax = c(82,515,995),
                ymin = c(0,0,0), ymax = c(34,34,34), 
                fill=after_scale(clr_alpha(pal_col, 0.1))))
fig_CAH

#...............................................................................
#...............................................................................
## https://www.cedricscherer.com/2019/08/05/a-ggplot2-tutorial-for-beautiful-plotting-in-r/#panels
# library(patchwork)
# fig_CAH / (fig_Task_asym + fig_DC_asym)

ggsave(file="fig_Task_asym.svg", 
       plot=fig_Task_asym,
       width = 3, height = 2.5,
       units = "in",
       dpi = 1200)
ggsave(file="fig_DC_asym.svg", 
       plot=fig_DC_asym,
       width = 3, height = 2.5,
       units = "in",
       dpi = 1200)
ggsave(file="fig_CAH.svg", 
       plot=fig_CAH,
       width = 6, height = 2.6,
       units = "in",
       dpi = 1200)

#...............................................................................
#...............................................................................
#...............................................................................
# Others classification variables...............................................
summary(data$DC_Sum)
fig_DC_sum = ggplot(data, 
                     aes(x = `Cluster - MMHC (category)`,
                         y = DC_Sum)) + 
  # geom_hline(yintercept=0,
  #            linetype=1,
  #            size=0.5,
  #            color='black', alpha=0.3) +
  ggdist::stat_halfeye(adjust = .5,
                       width = .6,
                       .width = 0,
                       point_colour = NA,
                       aes(colour = `Cluster - MMHC (category)`,
                           fill=after_scale(clr_lighten(colour, 
                                                        space="combined")))) + 
  geom_linerange(aes(ymin = 11.53, 
                     ymax = 12.59, 
                     x = 1), ## position
                 color = pal_col[1],
                 size = 0.5) +
  geom_linerange(aes(ymin = 9.05,
                     ymax = 9.75,
                     x = 2), ## position
                 color = pal_col[2],
                 size = 0.5) +
  geom_linerange(aes(ymin = 11.77, 
                     ymax = 12.55, 
                     x = 3), ## position
                 color = pal_col[3],
                 size = 0.5) +
  geom_boxplot(width = .25, 
               size=0.5,
               outlier.shape = NA,
               aes(colour=`Cluster - MMHC (category)`,
                   fill=after_scale(clr_lighten(colour, 
                                                space="combined",
                                                shift = 0.755))),
               position = position_nudge(x = -0.2)) +
  geom_point(shape=21,
             size = 0.5,
             stroke = 0.25,
             colour = "white", fill = "white",
             position = position_jitternudge(jitter.width = .15,
                                             nudge.x = -0.2,
                                             seed = 1)) +
  geom_point(shape=21,
             size = 0.5,
             stroke = 0.25,
             aes(colour=`Cluster - MMHC (category)`, 
                 fill=after_scale(clr_alpha(colour, 0.4))),
             position = position_jitternudge(jitter.width = .15,
                                             nudge.x = -0.2,
                                             seed = 1)) + 
  theme_classic() + 
  theme(plot.title = element_blank(),
        text = element_text(family="Arial"),
        # axis.text.x = element_text(color="grey33"),
        ## make disappear the text of the x axis
        axis.text.x=element_blank(),
        panel.grid = element_line(size = 0.5),
        panel.grid.major.x = element_line(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.line.y = element_blank(),
        axis.line.x = element_blank(),
        axis.text = element_text(face = "plain",
                                 color = "black",
                                 size = 16),
        # axis.text.y = ggtext::element_markdown(colour=pal_col),
        ## make disappear the text of the y axis
        axis.text.y=element_blank(),
        axis.ticks.x = element_line(size=0),
        axis.ticks.y = element_blank(),
        legend.position = "none") + 
  scale_x_discrete(labels=c("","","")) +
  scale_y_continuous(breaks = scales::pretty_breaks(n = 10)) + # or n=5
  scale_color_manual(values=pal_col) +
  scale_fill_manual(values=pal_col)  +
  coord_flip(xlim = c(1.2, NA),
             ylim = c(4, 21),
             clip = "off")
fig_DC_sum
ggsave(file="fig_DC_sum.svg", 
       plot=fig_DC_sum,
       width = 3, height = 2.5,
       units = "in",
       dpi = 1200)
#...............................................................................
summary(data$STORYminusMath_Hubs_Asym)
fig_BOLD_hubs = ggplot(data, 
                    aes(x = `Cluster - MMHC (category)`,
                        y = STORYminusMath_Hubs_Asym)) + 
  geom_hline(yintercept=0,
             linetype=1,
             size=0.5,
             color='black', alpha=0.3) +
  ggdist::stat_halfeye(adjust = .5,
                       width = .6,
                       .width = 0,
                       point_colour = NA,
                       aes(colour = `Cluster - MMHC (category)`,
                           fill=after_scale(clr_lighten(colour, 
                                                        space="combined")))) + 
  geom_linerange(aes(ymin = -1.42, 
                     ymax = -0.9, 
                     x = 1), ## position
                 color = pal_col[1],
                 size = 0.5) +
  geom_linerange(aes(ymin = 1,
                     ymax = 1.34,
                     x = 2), ## position
                 color = pal_col[2],
                 size = 0.5) +
  geom_linerange(aes(ymin = 2.45, 
                     ymax = 2.83, 
                     x = 3), ## position
                 color = pal_col[3],
                 size = 0.5) +
  geom_boxplot(width = .25, 
               size=0.5,
               outlier.shape = NA,
               aes(colour=`Cluster - MMHC (category)`,
                   fill=after_scale(clr_lighten(colour, 
                                                space="combined",
                                                shift = 0.755))),
               position = position_nudge(x = -0.2)) +
  geom_point(shape=21,
             size = 0.5,
             stroke = 0.25,
             colour = "white", fill = "white",
             position = position_jitternudge(jitter.width = .15,
                                             nudge.x = -0.2,
                                             seed = 1)) +
  geom_point(shape=21,
             size = 0.5,
             stroke = 0.25,
             aes(colour=`Cluster - MMHC (category)`, 
                 fill=after_scale(clr_alpha(colour, 0.4))),
             position = position_jitternudge(jitter.width = .15,
                                             nudge.x = -0.2,
                                             seed = 1)) + 
  theme_classic() + 
  theme(plot.title = element_blank(),
        text = element_text(family="Arial"),
        # axis.text.x = element_text(color="grey33"),
        ## make disappear the text of the x axis
        axis.text.x=element_blank(),
        panel.grid = element_line(size = 0.5),
        panel.grid.major.x = element_line(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.line.y = element_blank(),
        axis.line.x = element_blank(),
        axis.text = element_text(face = "plain",
                                 color = "black",
                                 size = 16),
        # axis.text.y = ggtext::element_markdown(colour=pal_col),
        ## make disappear the text of the y axis
        axis.text.y=element_blank(),
        axis.ticks.x = element_line(size=0),
        axis.ticks.y = element_blank(),
        legend.position = "none") + 
  scale_x_discrete(labels=c("","","")) +
  scale_y_continuous(breaks = scales::pretty_breaks(n = 10)) + # or n=5
  scale_color_manual(values=pal_col) +
  scale_fill_manual(values=pal_col)  +
  coord_flip(xlim = c(1.2, NA),
             ylim = c(-6.1, 6.6),
             clip = "off")
fig_BOLD_hubs
ggsave(file="fig_BOLD_hubs.svg", 
       plot=fig_BOLD_hubs,
       width = 3, height = 2.5,
       units = "in",
       dpi = 1200)
#...............................................................................
summary(data$fisherTransform_r_interHemi)
fig_r_Homo = ggplot(data, 
                       aes(x = `Cluster - MMHC (category)`,
                           y = fisherTransform_r_interHemi)) + 
  # geom_hline(yintercept=0,
  #            linetype=1,
  #            size=0.5,
  #            color='black', alpha=0.3) +
  ggdist::stat_halfeye(adjust = .5,
                       width = .6,
                       .width = 0,
                       point_colour = NA,
                       aes(colour = `Cluster - MMHC (category)`,
                           fill=after_scale(clr_lighten(colour, 
                                                        space="combined")))) + 
  geom_linerange(aes(ymin = 0.585, 
                     ymax = 0.635, 
                     x = 1), ## position
                 color = pal_col[1],
                 size = 0.5) +
  geom_linerange(aes(ymin = 0.475,
                     ymax = 0.505,
                     x = 2), ## position
                 color = pal_col[2],
                 size = 0.5) +
  geom_linerange(aes(ymin = 0.59, 
                     ymax = 0.63, 
                     x = 3), ## position
                 color = pal_col[3],
                 size = 0.5) +
  geom_boxplot(width = .25, 
               size=0.5,
               outlier.shape = NA,
               aes(colour=`Cluster - MMHC (category)`,
                   fill=after_scale(clr_lighten(colour, 
                                                space="combined",
                                                shift = 0.755))),
               position = position_nudge(x = -0.2)) +
  geom_point(shape=21,
             size = 0.5,
             stroke = 0.25,
             colour = "white", fill = "white",
             position = position_jitternudge(jitter.width = .15,
                                             nudge.x = -0.2,
                                             seed = 1)) +
  geom_point(shape=21,
             size = 0.5,
             stroke = 0.25,
             aes(colour=`Cluster - MMHC (category)`, 
                 fill=after_scale(clr_alpha(colour, 0.4))),
             position = position_jitternudge(jitter.width = .15,
                                             nudge.x = -0.2,
                                             seed = 1)) + 
  theme_classic() + 
  theme(plot.title = element_blank(),
        text = element_text(family="Arial"),
        # axis.text.x = element_text(color="grey33"),
        ## make disappear the text of the x axis
        axis.text.x=element_blank(),
        panel.grid = element_line(size = 0.5),
        panel.grid.major.x = element_line(),
        axis.title.x = element_blank(),
        axis.title.y = element_blank(),
        axis.line.y = element_blank(),
        axis.line.x = element_blank(),
        axis.text = element_text(face = "plain",
                                 color = "black",
                                 size = 16),
        # axis.text.y = ggtext::element_markdown(colour=pal_col),
        ## make disappear the text of the y axis
        axis.text.y=element_blank(),
        axis.ticks.x = element_line(size=0),
        axis.ticks.y = element_blank(),
        legend.position = "none") + 
  scale_x_discrete(labels=c("","","")) +
  scale_y_continuous(breaks = scales::pretty_breaks(n = 10)) + # or n=5
  scale_color_manual(values=pal_col) +
  scale_fill_manual(values=pal_col)  +
  coord_flip(xlim = c(1.2, NA),
             ylim = c(0.23, 1),
             clip = "off")
fig_r_Homo
ggsave(file="fig_r_Homo.svg", 
       plot=fig_r_Homo,
       width = 3, height = 2.5,
       units = "in",
       dpi = 1200)
