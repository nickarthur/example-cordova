//
//  HTSQLiteDatabase+HTTransmitterClient.h
//  HTTransmitter
//
//  Created by Ulhas Mandrawadkar on 19/08/16.
//  Copyright © 2016 HyperTrack, Inc. All rights reserved.
//

#import "HTSQLiteDatabase.h"

@interface HTSQLiteDatabase (HTTransmitterClient)

+ (HTSQLiteDatabase *)databaseForTransmitterClient;

@end
