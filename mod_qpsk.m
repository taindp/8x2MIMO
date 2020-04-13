function y = mod_qpsk(sym)
x_qpsk=[];
x_map=[1+1i 1-1i -1+1i -1-1i].*1/sqrt(2);
L=length(sym);
for i = 1:L
    if(sym(i)==0)
        x_qpsk(i)=x_map(1);
    elseif(sym(i)==1)
        x_qpsk(i)=x_map(2);
    elseif(sym(i)==2)
        x_qpsk(i)=x_map(3);
    else
        x_qpsk(i)=x_map(4);
    end
end
y=x_qpsk;