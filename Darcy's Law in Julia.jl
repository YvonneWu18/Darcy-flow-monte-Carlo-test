using Printf

N = 10_000 #Running 10,000 so n=10,000

#Darcy;s Law three constants
# A = 岩石的截面積，1平方米, 現實中取決於你打的井有多大、裂縫有多寬
# dP_dx = 壓力梯度，負號代表流體從高壓流向低壓, 這是「每走一米，壓力降低多少」。
# 負號代表流體從高壓流向低壓——就像水從高處流向低處一樣，流體從高壓區流向低壓區。
# μ = 水的黏度，就是水有多「稠」, 水在20°C的黏度大約是0.001 Pa·s——這是標準值。
# 黏度越高，流動越慢
A = 1000.0
dP_dx = -1000.0
μ = 0.01

# 這是滲透率k的不確定性設定:
# k的真實值我們不知道，只能估計
# 地質學上k用log-normal分佈——因為k可以從極小到極大變化很多個數量級
# 1e-13是典型砂岩的滲透率 #
# 1.2是不確定性的大小——越大代表我們越不確定
log_k_mean = log(1e-13)
log_k_std = 1.2

log_k_samples = log_k_mean .+ log_k_std .* randn(N)
k_samples = exp.(log_k_samples)
# randn(N) 隨機產生10,000個標準正態分佈的數字
# 第一行把它們轉換成log空間的k值
# 第二行用exp把log空間變回真實的k值
# .+ 和 .* 是Julia的向量運算，一次對10,000個數字同時計算


Q_samples = (-k_samples .* A .* dP_dx) ./ μ 
# Darcy's Law： Q = -k × A × (dP/dx) / μ
# 對10,000個k值每個都算一次流量Q，得到10,000個Q的結果。

Q_mean = mean(Q_samples)
Q_p10 = quantile(Q_samples, 0.10) # P10，10%的模擬結果低於這個值（悲觀情境）
Q_p90 = quantile(Q_samples, 0.90) # P90，90%的模擬結果低於這個值（樂觀情境）

@printf("Mean flow rate: %.6e m³/s\n", Q_mean)
@printf("Pessimistic P10: %.6e m³/s\n", Q_p10)
@printf("Optimistic P90: %.6e m³/s\n", Q_p90)
@printf("Range factor: %.1fx\n", Q_p90/Q_p10) # Range factor :即使流量本身小到顯示不出來，樂觀和悲觀情境之間還是差了xxx倍。