function value = AUC(Pf,Pd)
% ����Pf��Pd���ض�Ӧ��AUCֵ
Pf_diff=diff(Pf);
value=abs(sum(Pd(2:end).*Pf_diff));


end

