function y=fft_rx(y_rmcp,L_fft)
s=size(y_rmcp);
r=s(1);
L=s(2);
y_fft=[];
for k=1:r
    for i=0:(L/L_fft-1)
        y_fft(k,i*L_fft+1:i*L_fft+L_fft)=fft((y_rmcp(k,i*L_fft+1:i*L_fft+L_fft)),L_fft);
    end
end
%y=reshape(y_fft,L,1);
y=y_fft;