#include "stdio.h"
#include "xparameters.h"
#include "xgpiops.h"
#include "sleep.h"
#include "xscugic.h"
#include "xgpio.h"

#define GPIO_DEVICE_ID  		XPAR_XGPIOPS_0_DEVICE_ID
#define INTC_DEVICE_ID			XPAR_SCUGIC_SINGLE_DEVICE_ID
#define AXI_GPIO_DEVICE_ID		XPAR_GPIO_0_DEVICE_ID
#define AXI_GPIO_INTERRUPT_ID	XPAR_FABRIC_AXI_GPIO_0_IP2INTC_IRPT_INTR


#define EMIO0_LED      54

#define GPIO_CHANNEL1		1

XGpioPs_Config * ConfigPtr;
XScuGic_Config *IntcConfig;
XGpioPs Gpio;
XScuGic Intc;
XGpio 	AXI_Gpio;


void SetupInterruptSystem(XScuGic *GicInstancePtr, XGpio *AXI_Gpio,u16 AXI_GpioIntrId);
static void IntrHandler();
u32 key_press=0;

int main(){
	u32 led_value=1;

	printf("AXI GPIO interrupt test\n");


	ConfigPtr = XGpioPs_LookupConfig(GPIO_DEVICE_ID);
	XGpioPs_CfgInitialize(&Gpio, ConfigPtr,ConfigPtr->BaseAddr);


	XGpio_Initialize(&AXI_Gpio, AXI_GPIO_DEVICE_ID);


	XGpioPs_SetDirectionPin(&Gpio, EMIO0_LED, 1);
	XGpioPs_SetOutputEnablePin(&Gpio, EMIO0_LED, 1);


	XGpio_SetDataDirection(&AXI_Gpio, GPIO_CHANNEL1 ,0x00000001);


	XGpioPs_WritePin(&Gpio, EMIO0_LED,led_value);


	SetupInterruptSystem(&Intc, &AXI_Gpio, AXI_GPIO_INTERRUPT_ID);

	while(1){
		if(key_press){

			if(XGpio_DiscreteRead(&AXI_Gpio, GPIO_CHANNEL1) == 0){
				led_value = ~led_value;
				key_press = 0;


				XGpio_InterruptClear(&AXI_Gpio,0x00000001);


				XGpioPs_WritePin(&Gpio, EMIO0_LED,led_value);


				usleep(200000);


				XGpio_InterruptEnable(&AXI_Gpio,0x00000001);
			}
		}
	}
	return 0;
}

void SetupInterruptSystem(XScuGic *GicInstancePtr, XGpio *AXI_Gpio,u16 AXI_GpioIntrId){


	IntcConfig = XScuGic_LookupConfig(INTC_DEVICE_ID);
	XScuGic_CfgInitialize(GicInstancePtr, IntcConfig,IntcConfig->CpuBaseAddress);


	Xil_ExceptionInit();

	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
				(Xil_ExceptionHandler)XScuGic_InterruptHandler,GicInstancePtr);

	Xil_ExceptionEnableMask(XIL_EXCEPTION_IRQ);


	XScuGic_Connect(GicInstancePtr, AXI_GpioIntrId,
				(Xil_ExceptionHandler)IntrHandler,(void *)AXI_Gpio);

	XScuGic_Enable(GicInstancePtr, AXI_GpioIntrId);


	XScuGic_SetPriorityTriggerType(GicInstancePtr, AXI_GpioIntrId,0xA0, 0x1);


	XGpio_InterruptGlobalEnable(AXI_Gpio);
	XGpio_InterruptEnable(AXI_Gpio,0x00000001);
}

void IntrHandler(){
	printf("interrupt test!\n\r");
	key_press = 1;
	XGpio_InterruptDisable(&AXI_Gpio,0x00000001);

}
