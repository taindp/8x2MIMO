function y=add_cp(x,L_ifft,L_cp)
s=size(x);
r=s(1);
L=s(2);
x_cp=[];
for k=1:r
    for i=0:(L/L_ifft-1)
        x_cp(k,i*(L_cp+L_ifft)+1:i*(L_cp+L_ifft)+L_cp)=x(k,(i*L_ifft+L_ifft-L_cp+1):i*L_ifft+L_ifft);
        x_cp(k,(i+1)*L_cp+i*L_ifft+1:(i+1)*L_cp+i*L_ifft+L_ifft)=x(k,i*L_ifft+1:i*L_ifft+L_ifft);
    end
end
%y=reshape(x_cp,(L+(L*L_cp)/L_ifft),1);
y=x_cp;