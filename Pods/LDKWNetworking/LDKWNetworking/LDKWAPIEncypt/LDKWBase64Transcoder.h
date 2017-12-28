//
//  LDKWBase64Transcoder.h
//  LDKWNetworking
//
//  Created by lixingdong on 2017/10/16.
//

#ifndef LDKWBase64Transcoder_h
#define LDKWBase64Transcoder_h

#include <stdio.h>
#include <stdlib.h>
#include <stdbool.h>

size_t LDKWEstimateBas64EncodedDataSize(size_t inDataSize);
size_t LDKWEstimateBas64DecodedDataSize(size_t inDataSize);

bool LDKWBase64EncodeData(const void *inInputData, size_t inInputDataSize, char *outOutputData, size_t *ioOutputDataSize);
bool LDKWBase64DecodeData(const void *inInputData, size_t inInputDataSize, void *ioOutputData, size_t *ioOutputDataSize);

#endif /* LDKWBase64Transcoder_h */
