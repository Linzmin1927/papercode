function value = AUC(Pf,Pd)
% 给定Pf，Pd返回对应的AUC值
Pf_diff=diff(Pf);
value=abs(sum(Pd(2:end).*Pf_diff));


end

