function y=ifft_tx(x,L_ifft)
s=size(x);
L=s(2);
r=s(1);
x_ifft=[];
for k=1:r
    for i=0:(L/L_ifft-1)
        x_ifft(k,i*L_ifft+1:i*L_ifft+L_ifft)=ifft((x(k,i*L_ifft+1:i*L_ifft+L_ifft)),L_ifft);
    end
end
y=x_ifft;