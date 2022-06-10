#include "stdio.h"
#include "xparameters.h"
#include "xgpiops.h"
#include "sleep.h"
#include "xscugic.h"
#include "xgpio.h"

#define GPIO_DEVICE_ID  		            XPAR_XGPIOPS_0_DEVICE_ID
#define INTC_DEVICE_ID			            XPAR_SCUGIC_SINGLE_DEVICE_ID
#define AXI_GPIO_KEY_DEVICE_ID		        XPAR_GPIO_0_DEVICE_ID // (1) 0x41200000
#define AXI_GPIO_UPDOWN_KEY_DEVICE_ID       XPAR_GPIO_1_DEVICE_ID // (1) 0x41210000
#define AXI_GPIO_INTERRUPT_ID	            XPAR_FABRIC_AXI_GPIO_0_IP2INTC_IRPT_INTR
# define MYIP_ADDR                          XPAR_WATER_THRESHLOD_V1_0_BASEADDR // 0x43C00000

#define EMIO0_LED   54 // interrupt LED Display

#define GPIO_CHANNEL1	 1

XGpioPs_Config * ConfigPtr;
XScuGic_Config *IntcConfig;
XGpioPs Gpio;
XScuGic Intc;
XGpio 	GPIO_KEY;
XGpio 	GPIO_UPDOWN_KEY;

void SetupInterruptSystem(XScuGic *GicInstancePtr, XGpio *GPIO_KEY,u16 AXI_GpioIntrId);
static void IntrHandler();

u32 key_press=0;
u32 i = 0;
int btn_value;
int sw_value;

int main(){

	ConfigPtr = XGpioPs_LookupConfig(GPIO_DEVICE_ID);
	XGpioPs_CfgInitialize(&Gpio, ConfigPtr,ConfigPtr->BaseAddr);

	XGpio_Initialize(&GPIO_KEY, AXI_GPIO_KEY_DEVICE_ID);
    XGpio_Initialize(&GPIO_UPDOWN_KEY, AXI_GPIO_UPDOWN_KEY_DEVICE_ID);

	XGpioPs_SetDirectionPin(&Gpio, EMIO0_LED, 1);
	XGpioPs_SetOutputEnablePin(&Gpio, EMIO0_LED, 1);

	XGpio_SetDataDirection(&GPIO_KEY, GPIO_CHANNEL1 ,0x00000001);
    XGpio_SetDataDirection(&GPIO_UPDOWN_KEY, GPIO_CHANNEL1 ,0x00000001);

	XGpioPs_WritePin(&Gpio, EMIO0_LED, 0);

	SetupInterruptSystem(&Intc, &GPIO_KEY, AXI_GPIO_INTERRUPT_ID);

	while(1){
		if(key_press){
			btn_value = XGpio_DiscreteRead(&GPIO_KEY, GPIO_CHANNEL1);
            sw_value  = XGpio_DiscreteRead(&GPIO_UPDOWN_KEY, GPIO_CHANNEL1);
            ///////////////////////////////////////////////////////////////
            if (btn_value == 0){
                if (sw_value == 0) {
					XGpioPs_WritePin(&Gpio, EMIO0_LED, 1);
					key_press = 0;
					if (i < 8) {
						i = i +1;
					}
					else{
						i = 1;
					}
					XGpio_InterruptClear(&GPIO_KEY,0x00000001);
					Xil_Out32((u32)MYIP_ADDR, (u32)i);
					usleep(500000);
					XGpio_InterruptEnable(&GPIO_KEY,0x00000001);
                }
                else {
                    XGpioPs_WritePin(&Gpio, EMIO0_LED, 1);
                    key_press = 0;
                    if (i > 0) {
                        i = i -1;
                    }
                    else{
                        i = 7;
                    }
                    XGpio_InterruptClear(&GPIO_KEY,0x00000001);
                    Xil_Out32((u32)MYIP_ADDR, (u32)i);
                    usleep(500000);
                    XGpio_InterruptEnable(&GPIO_KEY,0x00000001);
                }
            }
            ///////////////////////////////////////////////////////////////
		}
		else{
			XGpioPs_WritePin(&Gpio, EMIO0_LED, 0);
		}
	}
	return 0;
}

void SetupInterruptSystem(XScuGic *GicInstancePtr, XGpio *GPIO_KEY,u16 AXI_GpioIntrId){


	IntcConfig = XScuGic_LookupConfig(INTC_DEVICE_ID);
	XScuGic_CfgInitialize(GicInstancePtr, IntcConfig,IntcConfig->CpuBaseAddress);


	Xil_ExceptionInit();

	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
				(Xil_ExceptionHandler)XScuGic_InterruptHandler,GicInstancePtr);

	Xil_ExceptionEnableMask(XIL_EXCEPTION_IRQ);


	XScuGic_Connect(GicInstancePtr, AXI_GpioIntrId,
				(Xil_ExceptionHandler)IntrHandler,(void *)GPIO_KEY);

	XScuGic_Enable(GicInstancePtr, AXI_GpioIntrId);


	XScuGic_SetPriorityTriggerType(GicInstancePtr, AXI_GpioIntrId,0xA0, 0x1);


	XGpio_InterruptGlobalEnable(GPIO_KEY);
	XGpio_InterruptEnable(GPIO_KEY,0x00000001);
}

void IntrHandler(){ // ISR --> Setting key value
	printf("interrupt test!\n\r");
	key_press = 1;
	usleep(500000); // debounce
	XGpio_InterruptDisable(&GPIO_KEY,0x00000001);
}
