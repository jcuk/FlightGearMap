//
//  main.cpp
//  CPDemo
//
//  Created by Jason Crane on 11/06/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#include <iostream>

#include "hidapi.h"
#include "defs.h"

#include "pasync.h"

enum tristate {on, off, unchanged};

void processSPMessage(uint32_t msg);
void sendSPMessage(uint32_t msg);
tristate getState(uint32_t msg, uint32_t msgChange, uint32_t mask);

uint32_t lastMsg = 0;

hid_device* switchPanel;


int main (int argc, const char * argv[])
{

    hid_init();
    
    //hid_device* radioPanel = hid_open(VENDOR_ID, RP_PROD_ID, NULL);
    //hid_device* multiPanel = hid_open(VENDOR_ID, MP_PROD_ID, NULL);
    switchPanel = hid_open(VENDOR_ID, SP_PROD_ID, NULL);
    
    if (!switchPanel) {
        std::cout << "Switch Panel not detected. Exiting\n";
    } else {
        std::cout << "Switch Panel detected. Starting\n";
        uint32_t message;
        
        //TODO: get inital device state without blocking for message:
        //lastMsg = ~message;
        
        //TODO: need to thread. Cn only block on one device
                
        for (;;) {
            //blocks for 100ms
            int mRes = hid_read_timeout((hid_device*)switchPanel, (uint8_t*)&message, sizeof(uint32_t), 100);
                        
            if (mRes > 0) {                
                processSPMessage(message);
            }

        }
    }
    
    return 0;
}

void processSPMessage(uint32_t msg) {
    uint32_t changes = lastMsg ^ msg;
    lastMsg = msg;
    
    tristate masterbat      = getState(msg,changes,SP_READ_MASTER_BAT_MASK);
    tristate masteralt      = getState(msg,changes,SP_READ_MASTER_ALT_MASK);
    tristate avionicsmaster = getState(msg,changes,SP_READ_AVIONICS_MASTER_MASK);
    tristate fuelpump       = getState(msg,changes,SP_READ_FUEL_PUMP_MASK);
    tristate deice          = getState(msg,changes,SP_READ_DE_ICE_MASK);
    tristate pitotheat      = getState(msg,changes,SP_READ_PITOT_HEAT_MASK);
    tristate cowl           = getState(msg,changes,SP_READ_COWL_MASK);
    tristate lightspanel    = getState(msg,changes,SP_READ_LIGHTS_PANEL_MASK);
    tristate lightsbeacon   = getState(msg,changes,SP_READ_LIGHTS_BEACON_MASK);
    tristate lightsnav      = getState(msg,changes,SP_READ_LIGHTS_NAV_MASK);
    tristate lightsstrobe   = getState(msg,changes,SP_READ_LIGHTS_STROBE_MASK);
    tristate lightstaxi     = getState(msg,changes,SP_READ_LIGHTS_TAXI_MASK);
    tristate lightslanding  = getState(msg,changes,SP_READ_LIGHTS_LANDING_MASK);
    tristate gearleverup    = getState(msg,changes,SP_READ_GEARLEVER_UP_MASK);
    tristate gearleverdown  = getState(msg,changes,SP_READ_GEARLEVER_DOWN_MASK);
    
    if (changes & SP_READ_ENGINES_KNOB_MASK) {
        uint32_t enginesknob = msg & SP_READ_ENGINES_KNOB_MASK;
        if (enginesknob == 0x002000) {
            msg = SP_MAGNETOS_OFF_CMD_MSG;
            std::cout << "Magnetos off\n";
        } else if (enginesknob == 0x004000) {
            msg = SP_MAGNETOS_RIGHT_CMD_MSG;
            std::cout << "Magnetos R\n";
        } else if (enginesknob == 0x008000) {
            msg = SP_MAGNETOS_LEFT_CMD_MSG;
            std::cout << "Magnetos L\n";
        } else if (enginesknob == 0x010000) {
            msg = SP_MAGNETOS_BOTH_CMD_MSG;
            std::cout << "Magnetos both\n";
        } else if (enginesknob == 0x020000) {
            msg = SP_ENGINE_START_CMD_MSG;
            std::cout << "Engine start\n";
        }
    }
    
    if (masterbat == on) {
        msg = SP_MASTER_BATTERY_ON_CMD_MSG;
        std::cout << "Master battery on\n";
    } else if (masterbat == off) {
        msg = SP_MASTER_BATTERY_OFF_CMD_MSG;
        sendSPMessage(SP_BLANK_SCRN_MSG);
        std::cout << "Master battery off\n";
    }
    
    if (masteralt == on) {
        msg = SP_MASTER_ALT_BATTERY_ON_CMD_MSG;
        std::cout << "Alt battery on\n";
    } else if (masteralt == off) {
        msg = SP_MASTER_ALT_BATTERY_OFF_CMD_MSG;
        std::cout << "Alt battery off\n";
    }
    
    if (avionicsmaster == on) {
        msg = SP_MASTER_AVIONICS_ON_CMD_MSG;
        std::cout << "Avionics master on\n";
    } else if (avionicsmaster == off) {
        msg = SP_MASTER_AVIONICS_OFF_CMD_MSG;
        std::cout << "Avionics master off\n";
    }
    
    if (fuelpump == on) {
        msg = SP_FUEL_PUMP_ON_CMD_MSG;
        std::cout << "Fuel pump on\n";
    } else if (fuelpump == off) {
        std::cout << "Fuel pump off\n";
        msg = SP_FUEL_PUMP_OFF_CMD_MSG;
    }
    
    if (deice == on) {
        std::cout << "Deice on\n";
        msg = SP_DEICE_ON_CMD_MSG;
    } else if (deice == off) {
        std::cout << "Deice off\n";
        msg = SP_DEICE_OFF_CMD_MSG;
    }
    
    if (pitotheat == on) {
        std::cout << "Pitot heat on\n";
        msg = SP_PITOT_HEAT_ON_CMD_MSG;
    } else if (pitotheat == off) {
        std::cout << "Pitot heat off\n";
        msg = SP_PITOT_HEAT_OFF_CMD_MSG;
    }
    
    if (cowl == on) {
        std::cout << "Cowl closed\n";
        msg = SP_COWL_CLOSED_CMD_MSG;
    } else if (cowl == off) {
        std::cout << "Cowl open\n";
        msg = SP_COWL_OPEN_CMD_MSG;
    }
    
    if (lightspanel == on) {
        std::cout << "Lights panel on\n";
        msg = SP_LIGHTS_PANEL_ON_CMD_MSG;
    } else if (lightspanel == off) {
        std::cout << "Lights panel off\n";
        msg = SP_LIGHTS_PANEL_OFF_CMD_MSG;
    }
    
    if (lightsbeacon == on) {
        std::cout << "Lights beacon on\n";
        msg = SP_LIGHTS_BEACON_ON_CMD_MSG;
    } else if (lightsbeacon == off) {
        std::cout << "Lights beacon off\n";
        msg = SP_LIGHTS_BEACON_OFF_CMD_MSG;
    }
    
    if (lightsnav == on) {
        std::cout << "Lights nav on\n";
        msg = SP_LIGHTS_NAV_ON_CMD_MSG;
    } else if (lightsnav == off) {
        std::cout << "Lights nav off\n";
        msg = SP_LIGHTS_NAV_OFF_CMD_MSG;
    }
    
    if (lightsstrobe == on) {
        std::cout << "Lights strobe on\n";
        msg = SP_LIGHTS_STROBE_ON_CMD_MSG;
    } else if (lightsstrobe == off) {
        std::cout << "Lights strobe off\n";
        msg = SP_LIGHTS_STROBE_OFF_CMD_MSG;
    }
    
    if (lightstaxi == on) {
        std::cout << "Lights taxi on\n";
        msg = SP_LIGHTS_TAXI_ON_CMD_MSG;
    } else if (lightstaxi == off) {
        std::cout << "Lights taxi off\n";
        msg = SP_LIGHTS_TAXI_OFF_CMD_MSG;
    }
    
    if (lightslanding == on) {
        std::cout << "Lights landing on\n";
        msg = SP_LIGHTS_LANDING_ON_CMD_MSG;
    } else if (lightslanding == off) {
        std::cout << "Lights landing off\n";
        msg = SP_LIGHTS_LANDING_OFF_CMD_MSG;
    }
    
    if (gearleverup == on) {
        msg = SP_LANDING_GEAR_UP_CMD_MSG;
        sendSPMessage(SP_ALL_RED_SCRN_MSG);
        std::cout << "Gear up\n";
    }
    
    if (gearleverdown == on) {
        msg = SP_LANDING_GEAR_DOWN_CMD_MSG;
        sendSPMessage(SP_ALL_GREEN_SCRN_MSG);
        std::cout << "Gear down\n";
    }
}

void sendSPMessage(uint32_t msg) {
    switch(msg) {
        case SP_ALL_GREEN_SCRN_MSG:
            hid_send_feature_report(switchPanel, sp_green_panel, sizeof(sp_green_panel));
            return;
        case SP_BLANK_SCRN_MSG:
            hid_send_feature_report(switchPanel, sp_blank_panel, sizeof(sp_blank_panel));
            return;
        case SP_ALL_RED_SCRN_MSG:
            hid_send_feature_report(switchPanel, sp_red_panel, sizeof(sp_red_panel));
            return;
        case SP_ALL_ORANGE_SCRN_MSG:
            hid_send_feature_report(switchPanel, sp_orange_panel, sizeof(sp_orange_panel));
            return;
        default:
            break;
    }
}

tristate getState(uint32_t msg, uint32_t msgChange, uint32_t mask) {

    if (!(msgChange & mask)) {
        return unchanged;
    }
    
    if (msg & mask) {
        return on;
    } else {
        return off;
    }

}

