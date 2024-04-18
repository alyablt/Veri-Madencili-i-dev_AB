#Veri Kaynağı (1. aşama)

#Veriyi toplama, kaynağın doğrulanması

#Veri satın alma, veriyi toplama, veriyi üretme, verinin açık bir yerden temini gibi aşamaları içermektedir.
#---

# Rastgele veri oluşturma için kütüphane
install.packages("MASS")
library(MASS)

# Veri setini oluşturma
set.seed(123) # Tekrarlanabilirlik için seed belirleme
n <- 100 # Gözlem sayısı
x1 <- rnorm(n, mean = 20, sd = 3) # Bağımsız değişken 1
x2 <- rnorm(n, mean = 10, sd = 2) # Bağımsız değişken 2
x3 <- rnorm(n, mean = 15, sd = 2.5) # Bağımsız değişken 3
x4 <- rnorm(n, mean = 7, sd = 1.5) # Bağımsız değişken 4
x5 <- rnorm(n, mean = 18, sd = 3) # Bağımsız değişken 5
y <- 3 + 2*x1 - 1.5*x2 + 2*x3 + 1.8*x4 - 1.2*x5 + rnorm(n, mean = 0, sd = 1) # Bağımlı değişken

# Oluşturulan veri setini bir veri çerçevesine dönüştürme
data <- data.frame(y, x1, x2, x3, x4, x5)

# Oluşturulan veri setini gösterme (head ilk altı satırı bize verir)
head(data)

#---
#Veri aktarımı ve gerekli ise Değişken dönüşümleri (2. aşama)
# Örnek veri setini oluşturma
set.seed(123)
n <- 200
x1_f <- rnorm(n, mean = 10, sd = 2) # x1_f yapmanın amacı bir önceki x’i okumaması için
x2_f <- rnorm(n, mean = 5, sd = 1)
y_f <- rnorm(n, mean = 3 + 2*x1 - 1.5*x2, sd = 2)

# x1 değişkenini faktörel değişkene dönüştürme
x1_f_factor <- as.factor(x1_f)

# x2 değişkenini sayısal değişkene dönüştürme
x2_f_numeric <- as.numeric(x2_f)

# Değişken türlerini kontrol etme
# Veri kümesinin yapısını (veri türleri, değişken adları vb.) görüntüler.
str(x1_f_factor) 
str(x2_f_numeric)
#---

#---

#Veri Kalitesi (3. aşama)
#Eksik veri tespiti ve eksik veri atama

# Örnek veri setini oluşturma
set.seed(123)
n <- 200
x1_ev <- rnorm(n, mean = 5, sd = 1)
x2_ev <- rnorm(n, mean = 3, sd = 0.5)
y_ev <- rnorm(n, mean = 3 + 2*x1 - 1.5*x2, sd = 2)

# Eksik veri tespiti  
is_na_x1 <- is.na(x1_ev) #viev(is_na_x1) veriyi biz ürettiğimiz için kayıp veri yok, ancak istersek bir kaç veri silip TRUE görebiliriz
is_na_x2 <- is.na(x2_ev)

# Eksik verileri ortalama ile doldurma (Ortalama yaygın olarak kullanılır. Normal dağılmayan durumlarda ortalama atama tercih edilmemelidir. Bunun yerine medyan düşünülebilir.)
mean_x1_ev <- mean(x1, na.rm = TRUE) #rm düşürme fonksiyonu
x1_filled <- ifelse(is.na(x1_ev), 
                    mean_x1, x1) 

#--- 
#Zamansal bir veride zaman serilerinde ortalamaya göre atama yapmak iyi bir fikir değil ve bu fonksiyonu kullanmak gerekir. Bu nedenle R’da bulunan na.locf() fonksiyonu kullanılır.
#na.locf() fonksiyonu eksik değerleri, geriye doğru olarak hemen öncesindeki değer ile dolduruyor. Bunun ileri doğru olanı da var.
#na.locf()"sonraki değeri kullanarak eksik değerleri doldurma" anlamına gelir. 
#"LOCF" kısaltması "Last Observation Carried Forward" ifadesinin kısaltmasıdır.
#Yani, eksik değer bir gözlemde bulunuyorsa, bu gözlemin bir önceki gözleminin değeriyle doldurulur.

install.packages("zoo") #na.locf() fonksiyonu
library(zoo)

# Örnek vektör oluşturma
vec <- c(1, NA, NA, 4, NA, 6, NA, 8, NA, NA, 6, NA, NA, 2, NA, NA, 9, NA, NA, 8, 8, NA)

# Eksik değerleri LOCF yöntemiyle doldurma
vec_filled <- na.locf(vec)

print(vec_filled) # bu fonksiyon ile yukarıda yazılı olan NA’ları doldurduğumuzu görüyoruz.

#---

# Eksik verileri en yakın değerle doldurma 
x2_filled <- na.locf(x2_ev) 

# Eksik verileri medyan ile doldurma
median_y_ev <- median(y_ev, na.rm = TRUE)#içindeki NA’ları görmezden gelerek medyanı bulma (rm düşürme fonksiyonu)
median_y_ev2 <- outliers (y_ev, 0.5) #Hocam burada hata aldım düzeltemedim. Aykırı değerler için neden hata verdi anlamadım.
y_filled <- ifelse(is.na(y_ev), median_y_ev, y_ev)

#Aykırı değer tespiti
# Örnek veri setini oluşturma
set.seed(123) # data ürettik
data <- rnorm(400) # ortalama ve ss girmedik. Her hangi birşey yazmazsak bize sıfır ortalamalı bir ss veri üretir.

# Kutu grafiği oluşturma
boxplot(data)
sort(data)# veriyi görmek istediğimizde bu fomksiyonu yazıyoruz. (iki aykırı değer var)

# Z-skoru hesaplama z_scores == data  dersek
z_scores <- scale(data) # Bu fonksiyonda z skorlarını görüyoruz. -3,+3 den sonrasını aykırı değer olarak görür.

z_scores == data # z skorlarını görürürüz
sort (z_scores) # 
mean(data) # Her ne kadar ort 0, ss 1 veri üretsekte ölçeklemede ortalamanın değiştiğini ve sıfır olmadığını görürüz.(data[1]-mean(data))/sd(data) # data 1’in z skorunu hesaplamış olduk. şimdi bunu görmek için aşağıdaki fonksiyonu kullanıyoruz.
data[1] #data 1’in ne olduğunu görmüş oluyoruz. ([1] 0.01677533 değerini bulduk)

# Aykırı değerleri belirleme
outliers <- abs(z_scores) > 3 #abs mutlak fonksiyon
outliers #aykırı değer olup olmadığını görürüz. FALSE aldık aykırı değer yok

# Alt ve üst çeyreklikleri hesaplama
Q1 <- quantile(data, 0.25)
Q2 <- quantile(data, 0.50)
Q3 <- quantile(data, 0.75)

# Alt ve üst sınırı hesaplama
IQR <- Q3 - Q1 # IQR  Q1 ve Q3 farkı
lower_bound <- Q1 - 1.5 * IQR # veriyi sola genişlet
upper_bound <- Q3 + 1.5 * IQR # veriyi sağa doğru genişlet

# Aykırı değerleri belirleme
outliers <- data < lower_bound | data > upper_bound #aykırı değer tespit etmiş oluyoruz.

#---

#---

#Dağılımları Keşif (4. aşama)

# Örnek veri setini oluşturma
set.seed(123)
data <- rnorm(200)

# Histogram oluşturma
#Histogram ile dağılımı inceliyoruz.
hist(data)

# Kutu grafiği oluşturma
# Kutu-bıyık grafiği ile aykırı değerleri inceliyoruz.
boxplot(data) 

# Q-Q plot oluşturma
# Q-Q plot bazen kararsız kaldığımızda Jarque-Bera sınaması yapabiliriz.
qqnorm(data)
qqline(data)

# Kantillerden yararlanma
summary(data)

# Örnek veri setini oluşturma
set.seed(123)
x <- rnorm(400) # Yordayıcı değişken
y <- 2*x + rnorm(400, mean = 0, sd = 0.5) # Yordanan değişkeni oluşturduk

# Korelasyon katsayısını hesaplama
correlation <- cor(x, y) 

# Korelasyon katsayısını ekrana yazdırma
print(correlation) #0.969 çok yüksek pozitif korelasyon bulduk.

#Multicollinearity (çoklu bağlantı problemi)
# Örnek veri setini oluşturma
set.seed(123)
x1 <- rnorm(200) # Yordayıcı değişken 1
x2 <- rnorm(200) # Yordayıcı değişken 2
x3 <- rnorm(200) # Yordayıcı değişken 3
y <- 2*x1 + 3*x2 - 1.5*x3 + rnorm(200, mean = 0, sd = 0.5) # Yordanan değişken

# Çoklu doğrusal regresyon modelini oluşturma 
# Ekstra paket yüklemeye  gerek kalmadan lm yazarak regresyon analizi yapabiliriz
model <- lm(y ~ x1 + x2 + x3)

#p değerinin tam olarak çıkması için scipen
options(scipen = 999)

# Model özetini alma
summary(model)

#F istatistiği bize anlamlı bir refresyon modeli olduğunu söylüyor.
#Analiz sonucunda anlamlı bir regresyon modeli F= 3767, p <0.001 
#ve bağımlı değişkendeki varyansın %98.3’ünün (R2(Adjusted)  = 0.9827) bağımsız değişkenler tarafından açıklandığı belirlenmiştir. 

# Yordayıcı değişkenler arasındaki korelasyonu hesaplama
correlation_matrix <- cor(data.frame(x1, x2, x3))
print(correlation_matrix)

# corrplot paketini yükleme
install.packages("corrplot") 
library(corrplot)

# Korelasyon matrisini görselleştirme
corrplot(correlation_matrix, method = "color")


# Yordayıcı değişkenlerin grafiğini çizme
par(mfrow=c(1,3)) # Grafiklerin yan yana yerleştirilmesi için 
plot(x1, y, main = "x1 vs. y", xlab = "x1", ylab = "y", col = "skyblue", pch = 16)
plot(x2, y, main = "x2 vs. y", xlab = "x2", ylab = "y", col = "pink", pch = 16)
plot(x3, y, main = "x3 vs. y", xlab = "x3", ylab = "y", col = "green", pch = 16)


# Örnek veri setini oluşturma
set.seed(123)
x1 <- rnorm(200) # Yordayıcı değişken 1
x2 <- rnorm(200) # Yordayıcı değişken 2
x3 <- rnorm(200) # Yordayıcı değişken 3
y <- 2*x1 + 3*x2 - 1.5*x3 + rnorm(200, mean = 0, sd = 1) # Yordanan değişken

# Veriyi standartlaştırma
x1_standardized <- scale(x1) # scale ölçeklendirme
x2_standardized <- scale(x2)
x3_standardized <- scale(x3)
y_standardized <- scale(y)

# Standartlaştırılmış veriyi kontrol etme
summary(x1_standardized)
summary(x2_standardized)
summary(x3_standardized)
summary(y_standardized)

#---

#---
#Kategorik Keşif (5. aşama) 
#Derste değinmedik. İlerleyen haftalarda konuşacağız
#

#---
#Son Değişiklik (6. aşama)
# caTools paketini yüklüyoruz
install.packages("caTools")
library(caTools)

# Veri setini oluşturma (örnek veri)
set.seed(123)
x1 <- rnorm(200) # Yordayıcı değişken 1
x2 <- rnorm(200) # Yordayıcı değişken 2
x3 <- rnorm(200) # Yordayıcı değişken 3
y <- 2*x1 + 3*x2 - 1.5*x3 + rnorm(200, mean = 0, sd = 0.5)

# Veriyi test ve eğitim alt kümelerine böleme
split <- sample.split(y, SplitRatio = 0.7) # 70% eğitim, 30% test #eğitimin %50’den yukarı olması önerilir.
train_data <- subset(data.frame(x1, x2, x3, y), split == TRUE)
test_data <- subset(data.frame(x1, x2, x3, y), split == FALSE)

# Verinin boyutlarını kontrol etme
dim(train_data)
dim(test_data)
