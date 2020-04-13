clear all
%Xilinx System Generator
L=1103;
fs=61.44e6;
f=15.36e6;
L_ifft=4096;
L_fft=4096;
L_cp=288;
L_sub=3000;
N_tx=8;
N_rx=2;
%generate sine wave f=15.36Mhz
%n=0:1/fs:(L-1)/(fs);
if (mod(L,N_tx)>0)
    L_pad=L+(N_tx-mod(L,N_tx));
else
    L_pad=L;
end
fpga_clock=1/fs;
master_reset = zeros(200000,2);
for t = 0:199999
    master_reset(t+1,1) = t;
    master_reset(t+1,1) = master_reset(t+1,1)/(4*fs);
end
master_reset(1,2)=1;
%master_reset(2,2)=1;
%Control ROM

k_full_data=L_sub; %6000
k_full_zero1=(ceil(((L_ifft-k_full_data)/2))+L_cp)*2;
k_full_zero2=(floor(((L_ifft-k_full_data)/2)))*2;
k_full=k_full_zero1+k_full_zero2+2*k_full_data; 

k_full_block=(floor(L_pad/(2*k_full_data)));

k_final_data=(mod(L_pad,(2*k_full_data)));    %final samples
if(k_final_data ~= 0)
    k_final_zero1=(floor(((L_ifft-(k_final_data)/2)/2))+L_cp)*2;  %final samples zero
    k_final_zero2=(ceil(((L_ifft-(k_final_data)/2)/2)))*2;
    k_final=k_final_zero1+k_final_zero2+k_final_data;
else
    k_final_zero1=0;
    k_final_zero2=0;
    k_final=2;
end

%--------------------------------------------------------------------------
%----------------------------TRANSMITTER-----------------------------------
%parameter
x=zeros(1,L_pad);
%x(1:L)=sin(2*pi*f*n);
x(1:L)=randi(16,L,1);
x_fix=bin(fi(x,0,16,12));

%CHANNEL CODING
x_cw=channel_coding(x_fix);
x_cw0=x_cw(:,1);
x_cw1=x_cw(:,2);
x_cw0_rs=reshape(x_cw0,2,length(x_cw0)/2);
x_cw0_rs=imrotate(x_cw0_rs,-90);
x_cw1_rs=reshape(x_cw1,2,length(x_cw1)/2);
x_cw1_rs=imrotate(x_cw1_rs,-90);
x_sym0=bi2de(x_cw0_rs);
x_sym1=bi2de(x_cw1_rs);


%MODULATION QPSK
x_sym0_mod=mod_qpsk(x_sym0);
x_sym1_mod=mod_qpsk(x_sym1);


%LAYER MAPPING
x_layer=layer_map(x_sym0_mod,x_sym1_mod);

%PRECODING
x_precod_mat=precoder_mat(x_layer);

%PADDING ZERO
x_pad=zero_pad(x_precod_mat,L_ifft,L_sub);

%IFFT 4096
x_ifft=ifft_tx(x_pad,L_ifft);

%ADD CYCLIC PREFIX
x_cp=add_cp(x_ifft,L_ifft,L_cp);

TX=x_cp;

%----------------------------Channel MMSE----------------------------------

%CHANNEL MATRIX
H=sqrt(1/2).*(randn(N_rx,N_tx)+1i.*randn(N_rx,N_tx));
%Workspace to XSG
H11_r=real(H(1,1));
H11_i=imag(H(1,1));
H12_r=real(H(1,2));
H12_i=imag(H(1,2));
H21_r=real(H(2,1));
H21_i=imag(H(2,1));
H22_r=real(H(2,2));
H22_i=imag(H(2,2));

%NOISE
snr_db=20;
snr = 10^(snr_db/10);
At=mean(mean(TX.'.*conj(TX.')));
An=At/snr;
n=sqrt(An/2).*(randn(N_rx,length(TX))+1i.*randn(N_rx,length(TX)));

%-----------------------------RECEIVER-------------------------------------
RX=H*TX+n;

%REMOVAL CYCLIC PREFIX
y_rmcp=removal_cp(RX,L_fft,L_cp);

%FFT 4096
y_fft=fft_rx(y_rmcp,L_fft);

%MMSE ESTIMATION
y_est=channel_est(y_fft,H);

y_round=round_qpsk(y_est);
y_round=reshape(y_round,1,2*length(y_round));
y_dm=demod_qpsk(y_est);
const_qpsk(y_round);

%RECOVER CODEWORD
y_cw0(:,1)=y_dm(:,1);
y_cw0(:,2)=y_dm(:,2);
y_cw1(:,1)=y_dm(:,3);
y_cw1(:,2)=y_dm(:,4);
y_cw0_rot=imrotate(y_cw0,90);
y_cw1_rot=imrotate(y_cw1,90);
y_cw0_rs=reshape(y_cw0_rot,length(x_cw0_rs)*2,1);
y_cw1_rs=reshape(y_cw1_rot,length(x_cw1_rs)*2,1);

%DECODING
y_dec=channel_decod(y_cw0_rs,y_cw1_rs);