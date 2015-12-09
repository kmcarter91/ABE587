source("functions.R")
library(biom)
library(vegan)
library(labdsv)
library(plyr)
library(IDPmisc)

#Load Data
lillis=load("lillis.rdata")
swabs=read_biom("otu_table_mc2_w_tax_json.biom")
swabs.metadata=read.table("swab_metadata.txt")

#Reformat Data
row.names(swabs.metadata)[c(1,2,3,4,5,6,7,8)]= c("Swab.162.2","Swab.162.3",
      "Swab.162.4","Swab.162.5","Swab.162.6","Swab.162.7","Swab.162.8","Swab.162.9")

swabs.otus=biom_data(swabs)

#convert taxonomy data into data.frame
swabs.taxonomy=observation_metadata(swabs)
swabs.taxonomy.df=lapply(swabs.taxonomy,as.data.frame(t))
swabs.taxonomy.df.2=do.call(rbind.fill,swabs.taxonomy.df)
swabs.taxonomy.df.2=do.call(rbind.fill,swabs.taxonomy.df)
#Identify which do not belong to Bacteria & Streptophyta
unidentifiable=which(swabs.taxonomy.df.2$"taxonomy"=="Unassigned")
nonbacteria=which(swabs.taxonomy.df.2$"value.taxonomy1"!="k__Bacteria")
streptophyta=which(swabs.taxonomy.df.2$"value.taxonomy4"=="o__Streptophyta")
swabs.taxonomy.df.2=swabs.taxonomy.df.2[-c(unidentifiable,nonbacteria,streptophyta),]


#Filter OTUs
swabs.otus.tmp=as.matrix(swabs.otus)
swabs.otus.tmp=data.frame(swabs.otus.tmp)
swabs.otus.tmp=swabs.otus.tmp[,row.names(swabs.metadata)]
swabs.otus.tmp=swabs.otus.tmp[rownames(swabs.taxonomy.df.2),]


#Rarefy OTU table to 4000
swab.otus = rrarefy(t(swabs.otus.tmp), 4000)
swab.otus = swab.otus[,which(apply(swab.otus,2,sum)>0)]
swab.taxonomy = swabs.taxonomy.df.2[colnames(swab.otus),]

#Calculate Canberra Distance Matrix
swab.canberra = vegdist(swab.otus, 'canberra')

write.table(as.matrix(swab.canberra),file='canberra_distances.txt',sep='\t',quote=FALSE)

#PERMAnova using Adonis
adonis(swab.canberra ~ swab.map$type)

#PERMAnova using capscale
swab.caps = capscale(swab.canberra ~ swab.map$type)
anova(swab.caps)

swab.caps2 = capscale(swab.otus ~ swab.map$type, distance='canberra')
anova(swab.caps2)
swab.caps2.plot = plot(swab.caps2)

#Indicator Taxa
full.caps = data.frame(swab.caps2.plot$species[,c(1,2)])
chair.caps = full.caps[which(full.caps$CAP1 > 0 & full.caps$CAP2 > 0),]
desk.caps = full.caps[which(full.caps$CAP1 > 0 & full.caps$CAP2 < 0),]
wall.caps = full.caps[which(full.caps$CAP1 < 0 & full.caps$CAP2 < 0),]
floor.caps = full.caps[which(full.caps$CAP1 < 0 & full.caps$CAP2 > 0),]

#Extant OTU picking
hypot <- function(d.f) {
  sqrt.d.f <- sqrt((d.f[, 1]^2) + (d.f[, 2]^2))
  invisible(sqrt.d.f)
}

#Pick strongest weighted OTUs#
hypot.chair = hypot(chair.caps)
chair.tops = chair.caps[rev(order(hypot.chair)), ][1:10, ]

hypot.desk = hypot(desk.caps)
desk.tops = desk.caps[rev(order(hypot.desk)), ][1:10, ]

hypot.wall = hypot(wall.caps)
wall.tops = wall.caps[rev(order(hypot.wall)), ][1:10, ]

hypot.floor = hypot(floor.caps)
floor.tops = floor.caps[rev(order(hypot.floor)), ][1:10, ]

species.caps = scores(swab.caps2)$species

#Clean taxonomy table
taxons = cleanTaxo(swab.taxonomy)
taxons=taxons[,-8]
taxons[,8]=colSums(swab.otus)
colnames(taxons) = c("kingdom","phylum","class","order","family","genus","species","abundance")

#Attach taxonomy to highest weighted taxa
chair.tops$kingdom <- taxons[row.names(chair.tops), 1]
desk.tops$kingdom <- taxons[row.names(desk.tops), 1]
wall.tops$kingdom <- taxons[row.names(wall.tops), 1]
floor.tops$kingdom <- taxons[row.names(floor.tops), 1]

chair.tops$phylum <- taxons[row.names(chair.tops), 2]
desk.tops$phylum <- taxons[row.names(desk.tops), 2]
wall.tops$phylum <- taxons[row.names(wall.tops), 2]
floor.tops$phylum <- taxons[row.names(floor.tops), 2]

chair.tops$class <- taxons[row.names(chair.tops), 3]
desk.tops$class <- taxons[row.names(desk.tops), 3]
wall.tops$class <- taxons[row.names(wall.tops), 3]
floor.tops$class <- taxons[row.names(floor.tops), 3]

chair.tops$order <- taxons[row.names(chair.tops), 4]
desk.tops$order <- taxons[row.names(desk.tops), 4]
wall.tops$order <- taxons[row.names(wall.tops), 4]
floor.tops$order <- taxons[row.names(floor.tops), 4]

chair.tops$family <- taxons[row.names(chair.tops), 5]
desk.tops$family <- taxons[row.names(desk.tops), 5]
wall.tops$family <- taxons[row.names(wall.tops), 5]
floor.tops$family <- taxons[row.names(floor.tops), 5]

chair.tops$genus <- taxons[row.names(chair.tops), 6]
desk.tops$genus <- taxons[row.names(desk.tops), 6]
wall.tops$genus <- taxons[row.names(wall.tops), 6]
floor.tops$genus <- taxons[row.names(floor.tops), 6]

chair.tops$species <- taxons[row.names(chair.tops), 7]
desk.tops$species <- taxons[row.names(desk.tops), 7]
wall.tops$species <- taxons[row.names(wall.tops), 7]
floor.tops$species <- taxons[row.names(floor.tops), 7]

chair.tops$pos <- 1
desk.tops$pos <- 1
wall.tops$pos <- 1
floor.tops$pos <- 1

cap.txt <- data.frame(x=c(1.3, 1.1, -.8, -1), 
                      y=c(.75, -.2, -1, .75))

#Check Indicator Significance
indic = indval(swab.otus,clustering=as.numeric(swab.map$type))

chair.ids = paste(row.names(chair.tops),sep='')
desk.ids <- paste(row.names(desk.tops), sep='')
wall.ids <- paste(row.names(wall.tops), sep='')
floor.ids <- paste(row.names(floor.tops), sep='')

chair.tops$indic <- indic$pval[chair.ids]
desk.tops$indic <- indic$pval[desk.ids]
wall.tops$indic <- indic$pval[wall.ids]
floor.tops$indic <- indic$pval[floor.ids]

#Create table of highest indicators
all.tops <- rbind(chair.tops, desk.tops, wall.tops, floor.tops)
all.tops$surface <- factor(c(rep('chair', nrow(chair.tops)), 
                             rep('desk', nrow(desk.tops)), 
                             rep('wall', nrow(wall.tops)), 
                             rep('floor', nrow(floor.tops))))
for(i in 1:nrow(all.tops)) {
  all.tops$chair.ra[i] <- 
    mean(swab.otus[swab.map$type == 'chair', row.names(all.tops)[i]] / 
           sum(swab.otus[swab.map$type == 'chair', ]))
  all.tops$desk.ra[i] <- 
    mean(swab.otus[swab.map$type == 'desk', row.names(all.tops)[i]] / 
           sum(swab.otus[swab.map$type == 'desk', ]))
  all.tops$wall.ra[i] <- 
    mean(swab.otus[swab.map$type == 'wall', row.names(all.tops)[i]] / 
           sum(swab.otus[swab.map$type == 'wall', ]))
  all.tops$floor.ra[i] <- 
    mean(swab.otus[swab.map$type == 'floor', row.names(all.tops)[i]] / 
           sum(swab.otus[swab.map$type == 'floor', ]))
}

all.tops

write.table(all.tops,file='surface_indicators.txt',sep='\t',quote=FALSE)

#longform OTU table
swabClass = aggregate(t(swab.otus),by=list(taxons$class),FUN='sum')
row.names(swabClass) = swabClass[,1]
swabClass = swabClass[,-1]
swabClass = data.frame(t(swabClass/4000))
swabClass = dematrify(swabClass)
swabAll=matrify(swabClass)

#Mapping Factor
sourcesMap = data.frame(env=rep('classroom',nrow(swabAll)))
row.names(sourcesMap)=row.names(swabAll)
sourcesMap$env = as.factor(sourcesMap$env)
sourcesMap$bg = swab.map$bg

#PCA
sourcesPCA = pca(swabAll)

#Plot
sourcesMap$col = 1
plot(sourcesPCA,type='n')
points(sourcesPCA$scores[,1:2],pch=21,bg=sourcesMap$bg,cex=2)
legend('bottomleft',legend=c('Chair','Desk',"Wall","Floor",levels(sourcesMap$env)[-1]),
       pch=c(rep(21,4),rep(16,5)),col=c(1,1,1,1,2:6),
       pt.bg=c('darkslateblue','goldenrod3','wheat','chocolate3'))

boxType = factor(swab.map$type,levels=c('chair','desk','wall','floor'))

##########################################
##ADAPTED FROM AUTHOR##
boxTypeNum <- rep(1, nrow(swab.map))
boxTypeNum[boxType == 'chair'] <- 1
boxTypeNum[boxType == 'desk'] <- 2
boxTypeNum[boxType == 'wall'] <- 3
boxTypeNum[boxType == 'floor'] <- 4

chair.caps <- chair.tops
desk.caps <- desk.tops
wall.caps <- wall.tops
floor.caps <- floor.tops

layout(matrix(c(1,2,3), 1, 3), widths=c(1,1,.75))
par(xpd=FALSE, mar=c(3,3,3,1), las=0)
plot(swab.caps, type='none', xaxt='n', yaxt='n', xlab='', ylab='')
mtext(c('CAP 1', 'CAP 2'), side=c(1,2), line=c(0.3, 0.1), adj=c(1,1))
points(swab.caps, 'sites', pch=21, bg=swab.map$bg, cex=2)
text(c(cap.txt$x), c(cap.txt$y), c('Chairs', 'Desks', 'Walls', 'Floors'), cex=1)
mtext('a', adj=0, font=2, cex=2)
plot(full.caps, pch=16, cex=.4, col=8, xlim=c(range(full.caps)), ylim=c(range(full.caps)),
     xaxt='n', yaxt='n', xlab='', ylab='')
mtext(c('CAP 1', 'CAP 2'), side=c(1,2), line=c(0.3, 0.1), adj=c(1,1))
abline(h=0, v=0, lty=3, lwd=.7, col=1)
# rect(-1.5, -1.5, 2, 2)
par(xpd=TRUE)
points(chair.caps$CAP1, chair.caps$CAP2, pch=21, bg='darkslateblue', cex=1, lwd=.5)
points(desk.caps$CAP1, desk.caps$CAP2, pch=21, bg='goldenrod3', cex=1, lwd=.5)
points(wall.caps$CAP1, wall.caps$CAP2, pch=21, bg='wheat', cex=1, lwd=.5)
points(floor.caps$CAP1, floor.caps$CAP2, pch=21, bg='chocolate3', cex=1, lwd=.5)
text(chair.caps$CAP1, chair.caps$CAP2, as.character(chair.caps$taxa), cex=.7, pos=chair.caps$pos)
text(desk.caps$CAP1, desk.caps$CAP2, as.character(desk.caps$taxa), cex=.7, pos=desk.caps$pos)
text(wall.caps$CAP1, wall.caps$CAP2, as.character(wall.caps$taxa), cex=.7, pos=wall.caps$pos)
text(floor.caps$CAP1, floor.caps$CAP2, as.character(floor.caps$taxa), cex=.7, pos=floor.caps$pos)
mtext('b', adj=0, font=2, cex=2)
par(mar=c(4,5,3,1))
boxplot(swab.map$plantskin ~ boxType, notch=TRUE,
        col=c('darkslateblue', 'goldenrod3', 'wheat', 'chocolate3'), 
        ylab='', las=1, pch=21, cex=0, bg=c('wheat', 'goldenrod3'))
points(swab.map$plantskin ~ jitter(boxTypeNum, .7), 
       pch=21, bg=swab.map$bg)
par(xpd=TRUE)
Arrows(-.55, 0.2, -.55, -.7, sh.col='gray40', sh.lwd=1.5, width=2.5, size=.5) 
Arrows(-.55, -.7, -.55, 0.2, sh.col='gray40', sh.lwd=1.5, width=2.5, size=.5) 
mtext('Source PCA Score', side=2, at=-.25, line=3.1, col='gray30', cex=.8)
mtext(c('Skin', 'Plants'), side=2, at=c(-.85, .4), line=2.5)
text(c(1,2,3,3.85), c(rep(.4, 4)), c('a', 'b', 'bc', 'c'), font=1, cex=1.4)
mtext('c', adj=0, font=2, cex=2)

#################################

#Mantel Tests
st.c = swab.table[swab.map$type == 'chair', ]
st.f = swab.table[swab.map$type == 'floor', ]
st.d = swab.table[swab.map$type == 'desk', ]
st.w = swab.table[swab.map$type == 'wall', ]

sm.c = swab.map[swab.map$type == 'chair', ]
sm.f = swab.map[swab.map$type == 'floor', ]
sm.d = swab.map[swab.map$type == 'desk', ]
sm.w = swab.map[swab.map$type == 'wall', ]

#Mantel Test for Chairs
mantel(vegdist(st.c, 'canberra'), vegdist(data.frame(sm.c$xcor, sm.c$ycor), 'euclid'))
#Mantel Test for Floors
mantel(vegdist(st.f, 'canberra'), vegdist(data.frame(sm.f$xcor, sm.f$ycor), 'euclid'))
#Mantel Test for Desks
mantel(vegdist(st.d, 'canberra'), vegdist(data.frame(sm.d$xcor, sm.d$ycor), 'euclid'))
#Mantel Test for Walls
mantel(vegdist(st.w, 'canberra'), vegdist(data.frame(sm.w$xcor, sm.w$ycor), 'euclid'))
#Mantel Test for all data
mantel(vegdist(swab.table, 'canberra'), vegdist(data.frame(swab.map$xcor, swab.map$ycor), 'euclid'))

#Plot
plot(vegdist(swab.table, 'canberra'), 
     vegdist(data.frame(swab.map$xcor, swab.map$ycor), 'euclid'))

#Pearson Correlation
cor.test(vegdist(swab.table, 'canberra'), 
         vegdist(data.frame(swab.map$xcor, swab.map$ycor), 'euclid'))

#PERMAnova for wall height
sm.2$location2 = factor(sm.w$location2)
adonis(vegdist(st.w,'canberra')~sm.w$location2)

#######################################
## Adapted from Author ##
t.phylum <- aggregate(t(swab.otus), by=list(taxons$phylum), sum)
t.class <- aggregate(t(swab.otus), by=list(taxons$class), sum)
t.order <- aggregate(t(swab.otus), by=list(taxons$order), sum)

#### phylum  1% cutoff
row.names(t.phylum) <- t.phylum$Group.1
t.phylum <- t.phylum[, -1]
t.phylum <- t.phylum[order(rowSums(t.phylum)), order(swab.map$type)]
nrows <- nrow(t.phylum)
nshow <- 7
nkeep <- nrows-nshow+1
t.phylum <- rbind(colSums(t.phylum[1:nkeep-1, ]), t.phylum[nkeep:nrows, ])
cols.8 <- c('#D73027', '#FC8D59', '#FEE090', '#FFFFBF', '#E0F3F8', '#91BFDB', '#9475B4', '#969A97')

# class  1% cutoff
row.names(t.class) <- t.class$Group.1
t.class <- t.class[, -1]
t.class <- t.class[order(rowSums(t.class)), order(swab.map$type)]
nrows <- nrow(t.class)
nshow <- 10
nkeep <- nrows-nshow+1
t.class <- rbind(colSums(t.class[1:nkeep-1, ]), t.class[nkeep:nrows, ])
t.class <- cbind(t.class[, 1:14][, rev(order(t.phylum[8, 1:14]))], 
                 t.class[, 15:29][, rev(order(t.phylum[8, 15:29]))], 
                 t.class[, 30:43][, rev(order(t.phylum[8, 30:43]))], 
                 t.class[, 44:58][, rev(order(t.phylum[8, 44:58]))] )
cols.11 <- c('#A50026', '#D73027', '#F46D43', '#FDAE61', '#FEE090', 
             '#E0F3F8', '#ABD9E9', '#74ADD1', '#4575B4', '#313695', '#969A97')

# order
row.names(t.order) <- t.order$Group.1
t.order <- t.order[, -1]
t.order <- t.order[order(rowSums(t.order)), order(swab.map$type)]
nrows <- nrow(t.order)
nshow <- 10
nkeep <- nrows-nshow+1
t.order <- rbind(colSums(t.order[1:nkeep-1, ]), t.order[nkeep:nrows, ])
t.order <- cbind(t.order[, 1:14][, rev(order(t.phylum[8, 1:14]))], 
                 t.order[, 15:29][, rev(order(t.phylum[8, 15:29]))], 
                 t.order[, 30:43][, rev(order(t.phylum[8, 30:43]))], 
                 t.order[, 44:58][, rev(order(t.phylum[8, 44:58]))] )
cols.11 <- c('#A50026', '#D73027', '#F46D43', '#FDAE61', '#FEE090', 
             '#E0F3F8', '#ABD9E9', '#74ADD1', '#4575B4', '#313695', '#969A97')
# create index for bar mid-points. 
bar <- barplot(as.matrix(t.order/4000), col=rev(cols.11))

####  this had to be run las to maintain phylum order in other charts
t.phylum <- cbind(t.phylum[, 1:14][, rev(order(t.phylum[8, 1:14]))], 
                  t.phylum[, 15:29][, rev(order(t.phylum[8, 15:29]))], 
                  t.phylum[, 30:43][, rev(order(t.phylum[8, 30:43]))], 
                  t.phylum[, 44:58][, rev(order(t.phylum[8, 44:58]))] )


ph.names <- row.names(t.phylum)
ph.names[1] <- 'other (<1%)'
cl.names <- row.names(t.class)
cl.names[1] <- 'other (<1%)'
or.names <- row.names(t.order)
or.names[1] <- 'other (<4%)'

# Taxonomy Bar Chart

layout(matrix(c(1,2,3, 7,1,2,3, 7,4,5,6, 7), 4, 3), heights=c(1,1,1,.1))
par(mar=c(1,4,2,1))
barplot(as.matrix(t.phylum/4000), col=rev(cols.8), border=rev(cols.8), xaxt='n', las=1)
mtext('Phylum', font=2, col='gray20')
segments(c(mean(bar[c(14,15)]), mean(bar[c(29,30)]), mean(bar[c(43,44)])), c(0,0,0),
         c(mean(bar[c(14,15)]), mean(bar[c(29,30)]), mean(bar[c(43,44)])), c(1,1,1))

mtext(c('chairs', 'desks', 'floors', 'walls'), side=1, 
      at=c(mean(bar[c(1,14)]), mean(bar[c(15,29)]), mean(bar[c(30,43)]), mean(bar[c(44,58)])), 
      font=2, col='gray20')  
barplot(as.matrix(t.class/4000), col=rev(cols.11), border=rev(cols.11), xaxt='n', las=1)
mtext('Class', font=2, col='gray20')
segments(c(mean(bar[c(14,15)]), mean(bar[c(29,30)]), mean(bar[c(43,44)])), c(0,0,0),
         c(mean(bar[c(14,15)]), mean(bar[c(29,30)]), mean(bar[c(43,44)])), c(1,1,1))
mtext(c('chairs', 'desks', 'floors', 'walls'), side=1, 
      at=c(mean(bar[c(1,14)]), mean(bar[c(15,29)]), mean(bar[c(30,43)]), mean(bar[c(44,58)])), 
      font=2, col='gray20')  
barplot(as.matrix(t.order/4000), col=rev(cols.11), border=rev(cols.11), xaxt='n', las=1)
mtext('Order', font=2, col='gray20')
segments(c(mean(bar[c(14,15)]), mean(bar[c(29,30)]), mean(bar[c(43,44)])), c(0,0,0),
         c(mean(bar[c(14,15)]), mean(bar[c(29,30)]), mean(bar[c(43,44)])), c(1,1,1))
par(xpd=TRUE)
mtext(c('chairs', 'desks', 'floors', 'walls'), side=1, 
      at=c(mean(bar[c(1,14)]), mean(bar[c(15,29)]), mean(bar[c(30,43)]), mean(bar[c(44,58)])), 
      font=2, col='gray20')  
par(mar=c(0,0,0,0))
plot(1,1, type='n', bty='n', xlab='', ylab='', xaxt='n', yaxt='n')
legend('left', legend=c(rev(ph.names)), pt.bg=cols.8, col=cols.8, bty='n', pch=22, cex=1, pt.cex=1.5)
plot(1,1, type='n', bty='n', xlab='', ylab='', xaxt='n', yaxt='n')
legend('left', legend=c(rev(cl.names)), pt.bg=cols.11, col=cols.11, bty='n', pch=22, cex=1, pt.cex=1.5)
plot(1,1, type='n', bty='n', xlab='', ylab='', xaxt='n', yaxt='n')
legend('left', legend=c(rev(or.names)), pt.bg=cols.11, col=cols.11, bty='n', pch=22, cex=1, pt.cex=1.5)


#######################################