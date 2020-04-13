function y=zero_pad(x,L_ifft,L_sub)
s=size(x);
s=s(1);
r=ceil(length(x)/L_sub);
x_pad=zeros(s,L_ifft*r);
z1=ceil((L_ifft-L_sub)/2)+1;   %549
z2=ceil(L_sub/2);              %1500
for i=1:s
for k=0:r-1
    if(k<r-1)
        x_pad(i,k*L_ifft+z1:k*L_ifft+z1+z2-1)=x(i,k*L_sub+1:k*L_sub+z2);
        x_pad(i,k*L_ifft+z1+z2+1:k*L_ifft+z1+2*z2)=x(i,k*L_sub+z2+1:k*L_sub+L_sub);
    else
        L_f=length(x)-k*L_sub; 
        if L_f==0
            x_pad(i,k*L_ifft+z1:k*L_ifft+z1+z2-1)=x(i,k*L_sub+1:k*L_sub+z2);
            x_pad(i,k*L_ifft+z1+z2+1:k*L_ifft+z1+2*z2)=x(i,k*L_sub+z2+1:k*L_sub+L_sub);
        else
            z3=ceil((L_ifft-L_f)/2)+1;
            z4=ceil(L_f/2);
            x_pad(i,k*L_ifft+z3:k*L_ifft+z3+z4-1)=x(i,k*L_sub+1:k*L_sub+z4);
            x_pad(i,k*L_ifft+z3+z4+1:k*L_ifft+z3+2*z4)=x(i,k*L_sub+z4+1:k*L_sub+L_f);
        end
    end
end
end
y=x_pad;