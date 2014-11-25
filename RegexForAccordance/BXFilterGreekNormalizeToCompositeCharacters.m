//
//  BXFilterGreekNormalizeToCompositeCharacters.m
//  RegexForAccordance
//
//  Created by Darin Franklin on 8/20/14.
//  Copyright (c) 2014 Darin Franklin. All rights reserved.
//

#import "BXFilterGreekNormalizeToCompositeCharacters.h"
#import "BXTextLanguage.h"

@implementation BXFilterGreekNormalizeToCompositeCharacters

-(id)init
{
    NSDictionary *map = [NSDictionary dictionaryWithObjectsAndKeys:
                         @"\u0391\u0301", @"\u0386", // GREEK CAPITAL LETTER ALPHA WITH TONOS
                         @"\u0395\u0301", @"\u0388", // GREEK CAPITAL LETTER EPSILON WITH TONOS
                         @"\u0397\u0301", @"\u0389", // GREEK CAPITAL LETTER ETA WITH TONOS
                         @"\u0399\u0301", @"\u038A", // GREEK CAPITAL LETTER IOTA WITH TONOS
                         @"\u039F\u0301", @"\u038C", // GREEK CAPITAL LETTER OMICRON WITH TONOS
                         @"\u03A5\u0301", @"\u038E", // GREEK CAPITAL LETTER UPSILON WITH TONOS
                         @"\u03A9\u0301", @"\u038F", // GREEK CAPITAL LETTER OMEGA WITH TONOS
                         @"\u03B9\u0308\u0301", @"\u0390", // GREEK SMALL LETTER IOTA WITH DIALYTIKA AND TONOS
                         @"\u0399\u0308", @"\u03AA", // GREEK CAPITAL LETTER IOTA WITH DIALYTIKA
                         @"\u03A5\u0308", @"\u03AB", // GREEK CAPITAL LETTER UPSILON WITH DIALYTIKA
                         @"\u03B1\u0301", @"\u03AC", // GREEK SMALL LETTER ALPHA WITH TONOS
                         @"\u03B5\u0301", @"\u03AD", // GREEK SMALL LETTER EPSILON WITH TONOS
                         @"\u03B7\u0301", @"\u03AE", // GREEK SMALL LETTER ETA WITH TONOS
                         @"\u03B9\u0301", @"\u03AF", // GREEK SMALL LETTER IOTA WITH TONOS
                         @"\u03C5\u0308\u0301", @"\u03B0", // GREEK SMALL LETTER UPSILON WITH DIALYTIKA AND TONOS
                         @"\u03B9\u0308", @"\u03CA", // GREEK SMALL LETTER IOTA WITH DIALYTIKA
                         @"\u03C5\u0308", @"\u03CB", // GREEK SMALL LETTER UPSILON WITH DIALYTIKA
                         @"\u03BF\u0301", @"\u03CC", // GREEK SMALL LETTER OMICRON WITH TONOS
                         @"\u03C5\u0301", @"\u03CD", // GREEK SMALL LETTER UPSILON WITH TONOS
                         @"\u03C9\u0301", @"\u03CE", // GREEK SMALL LETTER OMEGA WITH TONOS

                         @"\u03B1\u0313", @"\u1F00", // GREEK SMALL LETTER ALPHA WITH PSILI
                         @"\u03B1\u0314", @"\u1F01", // GREEK SMALL LETTER ALPHA WITH DASIA
                         @"\u03B1\u0313\u0300", @"\u1F02", // GREEK SMALL LETTER ALPHA WITH PSILI AND VARIA
                         @"\u03B1\u0314\u0300", @"\u1F03", // GREEK SMALL LETTER ALPHA WITH DASIA AND VARIA
                         @"\u03B1\u0313\u0301", @"\u1F04", // GREEK SMALL LETTER ALPHA WITH PSILI AND OXIA
                         @"\u03B1\u0314\u0301", @"\u1F05", // GREEK SMALL LETTER ALPHA WITH DASIA AND OXIA
                         @"\u03B1\u0313\u0342", @"\u1F06", // GREEK SMALL LETTER ALPHA WITH PSILI AND PERISPOMENI
                         @"\u03B1\u0314\u0342", @"\u1F07", // GREEK SMALL LETTER ALPHA WITH DASIA AND PERISPOMENI
                         @"\u0391\u0313", @"\u1F08", // GREEK CAPITAL LETTER ALPHA WITH PSILI
                         @"\u0391\u0314", @"\u1F09", // GREEK CAPITAL LETTER ALPHA WITH DASIA
                         @"\u0391\u0313\u0300", @"\u1F0A", // GREEK CAPITAL LETTER ALPHA WITH PSILI AND VARIA
                         @"\u0391\u0314\u0300", @"\u1F0B", // GREEK CAPITAL LETTER ALPHA WITH DASIA AND VARIA
                         @"\u0391\u0313\u0301", @"\u1F0C", // GREEK CAPITAL LETTER ALPHA WITH PSILI AND OXIA
                         @"\u0391\u0314\u0301", @"\u1F0D", // GREEK CAPITAL LETTER ALPHA WITH DASIA AND OXIA
                         @"\u0391\u0313\u0342", @"\u1F0E", // GREEK CAPITAL LETTER ALPHA WITH PSILI AND PERISPOMENI
                         @"\u0391\u0314\u0342", @"\u1F0F", // GREEK CAPITAL LETTER ALPHA WITH DASIA AND PERISPOMENI
                         @"\u03B5\u0313", @"\u1F10", // GREEK SMALL LETTER EPSILON WITH PSILI
                         @"\u03B5\u0314", @"\u1F11", // GREEK SMALL LETTER EPSILON WITH DASIA
                         @"\u03B5\u0313\u0300", @"\u1F12", // GREEK SMALL LETTER EPSILON WITH PSILI AND VARIA
                         @"\u03B5\u0314\u0300", @"\u1F13", // GREEK SMALL LETTER EPSILON WITH DASIA AND VARIA
                         @"\u03B5\u0313\u0301", @"\u1F14", // GREEK SMALL LETTER EPSILON WITH PSILI AND OXIA
                         @"\u03B5\u0314\u0301", @"\u1F15", // GREEK SMALL LETTER EPSILON WITH DASIA AND OXIA
                         //                   1F16 " <reserved>
                         //                   1F17 " <reserved>
                         @"\u0395\u0313", @"\u1F18", // GREEK CAPITAL LETTER EPSILON WITH PSILI
                         @"\u0395\u0314", @"\u1F19", // GREEK CAPITAL LETTER EPSILON WITH DASIA
                         @"\u0395\u0313\u0300", @"\u1F1A", // GREEK CAPITAL LETTER EPSILON WITH PSILI AND VARIA
                         @"\u0395\u0314\u0300", @"\u1F1B", // GREEK CAPITAL LETTER EPSILON WITH DASIA AND VARIA
                         @"\u0395\u0313\u0301", @"\u1F1C", // GREEK CAPITAL LETTER EPSILON WITH PSILI AND OXIA
                         @"\u0395\u0314\u0301", @"\u1F1D", // GREEK CAPITAL LETTER EPSILON WITH DASIA AND OXIA
                         //                   1F1E " <reserved>
                         //                   1F1F " <reserved>
                         @"\u03B7\u0313", @"\u1F20", // GREEK SMALL LETTER ETA WITH PSILI
                         @"\u03B7\u0314", @"\u1F21", // GREEK SMALL LETTER ETA WITH DASIA
                         @"\u03B7\u0313\u0300", @"\u1F22", // GREEK SMALL LETTER ETA WITH PSILI AND VARIA
                         @"\u03B7\u0314\u0300", @"\u1F23", // GREEK SMALL LETTER ETA WITH DASIA AND VARIA
                         @"\u03B7\u0313\u0301", @"\u1F24", // GREEK SMALL LETTER ETA WITH PSILI AND OXIA
                         @"\u03B7\u0314\u0301", @"\u1F25", // GREEK SMALL LETTER ETA WITH DASIA AND OXIA
                         @"\u03B7\u0313\u0342", @"\u1F26", // GREEK SMALL LETTER ETA WITH PSILI AND PERISPOMENI
                         @"\u03B7\u0314\u0342", @"\u1F27", // GREEK SMALL LETTER ETA WITH DASIA AND PERISPOMENI
                         @"\u0397\u0313", @"\u1F28", // GREEK CAPITAL LETTER ETA WITH PSILI
                         @"\u0397\u0314", @"\u1F29", // GREEK CAPITAL LETTER ETA WITH DASIA
                         @"\u0397\u0313\u0300", @"\u1F2A", // GREEK CAPITAL LETTER ETA WITH PSILI AND VARIA
                         @"\u0397\u0314\u0300", @"\u1F2B", // GREEK CAPITAL LETTER ETA WITH DASIA AND VARIA
                         @"\u0397\u0313\u0301", @"\u1F2C", // GREEK CAPITAL LETTER ETA WITH PSILI AND OXIA
                         @"\u0397\u0314\u0301", @"\u1F2D", // GREEK CAPITAL LETTER ETA WITH DASIA AND OXIA
                         @"\u0397\u0313\u0342", @"\u1F2E", // GREEK CAPITAL LETTER ETA WITH PSILI AND PERISPOMENI
                         @"\u0397\u0314\u0342", @"\u1F2F", // GREEK CAPITAL LETTER ETA WITH DASIA AND PERISPOMENI
                         @"\u03B9\u0313", @"\u1F30", // GREEK SMALL LETTER IOTA WITH PSILI
                         @"\u03B9\u0314", @"\u1F31", // GREEK SMALL LETTER IOTA WITH DASIA
                         @"\u03B9\u0313\u0300", @"\u1F32", // GREEK SMALL LETTER IOTA WITH PSILI AND VARIA
                         @"\u03B9\u0314\u0300", @"\u1F33", // GREEK SMALL LETTER IOTA WITH DASIA AND VARIA
                         @"\u03B9\u0313\u0301", @"\u1F34", // GREEK SMALL LETTER IOTA WITH PSILI AND OXIA
                         @"\u03B9\u0314\u0301", @"\u1F35", // GREEK SMALL LETTER IOTA WITH DASIA AND OXIA
                         @"\u03B9\u0313\u0342", @"\u1F36", // GREEK SMALL LETTER IOTA WITH PSILI AND PERISPOMENI
                         @"\u03B9\u0314\u0342", @"\u1F37", // GREEK SMALL LETTER IOTA WITH DASIA AND PERISPOMENI
                         @"\u0399\u0313", @"\u1F38", // GREEK CAPITAL LETTER IOTA WITH PSILI
                         @"\u0399\u0314", @"\u1F39", // GREEK CAPITAL LETTER IOTA WITH DASIA
                         @"\u0399\u0313\u0300", @"\u1F3A", // GREEK CAPITAL LETTER IOTA WITH PSILI AND VARIA
                         @"\u0399\u0314\u0300", @"\u1F3B", // GREEK CAPITAL LETTER IOTA WITH DASIA AND VARIA
                         @"\u0399\u0313\u0301", @"\u1F3C", // GREEK CAPITAL LETTER IOTA WITH PSILI AND OXIA
                         @"\u0399\u0314\u0301", @"\u1F3D", // GREEK CAPITAL LETTER IOTA WITH DASIA AND OXIA
                         @"\u0399\u0313\u0342", @"\u1F3E", // GREEK CAPITAL LETTER IOTA WITH PSILI AND PERISPOMENI
                         @"\u0399\u0314\u0342", @"\u1F3F", // GREEK CAPITAL LETTER IOTA WITH DASIA AND PERISPOMENI
                         @"\u03BF\u0313", @"\u1F40", // GREEK SMALL LETTER OMICRON WITH PSILI
                         @"\u03BF\u0314", @"\u1F41", // GREEK SMALL LETTER OMICRON WITH DASIA
                         @"\u03BF\u0313\u0300", @"\u1F42", // GREEK SMALL LETTER OMICRON WITH PSILI AND VARIA
                         @"\u03BF\u0314\u0300", @"\u1F43", // GREEK SMALL LETTER OMICRON WITH DASIA AND VARIA
                         @"\u03BF\u0313\u0301", @"\u1F44", // GREEK SMALL LETTER OMICRON WITH PSILI AND OXIA
                         @"\u03BF\u0314\u0301", @"\u1F45", // GREEK SMALL LETTER OMICRON WITH DASIA AND OXIA
                         //                   1F46 " <reserved>
                         //                   1F47 " <reserved>
                         @"\u039F\u0313", @"\u1F48", // GREEK CAPITAL LETTER OMICRON WITH PSILI
                         @"\u039F\u0314", @"\u1F49", // GREEK CAPITAL LETTER OMICRON WITH DASIA
                         @"\u039F\u0313\u0300", @"\u1F4A", // GREEK CAPITAL LETTER OMICRON WITH PSILI AND VARIA
                         @"\u039F\u0314\u0300", @"\u1F4B", // GREEK CAPITAL LETTER OMICRON WITH DASIA AND VARIA
                         @"\u039F\u0313\u0301", @"\u1F4C", // GREEK CAPITAL LETTER OMICRON WITH PSILI AND OXIA
                         @"\u039F\u0314\u0301", @"\u1F4D", // GREEK CAPITAL LETTER OMICRON WITH DASIA AND OXIA
                         //                   1F4E " <reserved>
                         //                   1F4F " <reserved>
                         @"\u03C5\u0313", @"\u1F50", // GREEK SMALL LETTER UPSILON WITH PSILI
                         @"\u03C5\u0314", @"\u1F51", // GREEK SMALL LETTER UPSILON WITH DASIA
                         @"\u03C5\u0313\u0300", @"\u1F52", // GREEK SMALL LETTER UPSILON WITH PSILI AND VARIA
                         @"\u03C5\u0314\u0300", @"\u1F53", // GREEK SMALL LETTER UPSILON WITH DASIA AND VARIA
                         @"\u03C5\u0313\u0301", @"\u1F54", // GREEK SMALL LETTER UPSILON WITH PSILI AND OXIA
                         @"\u03C5\u0314\u0301", @"\u1F55", // GREEK SMALL LETTER UPSILON WITH DASIA AND OXIA
                         @"\u03C5\u0313\u0342", @"\u1F56", // GREEK SMALL LETTER UPSILON WITH PSILI AND PERISPOMENI
                         @"\u03C5\u0314\u0342", @"\u1F57", // GREEK SMALL LETTER UPSILON WITH DASIA AND PERISPOMENI
                         //                   1F58 " <reserved>
                         @"\u03A5\u0314", @"\u1F59", // GREEK CAPITAL LETTER UPSILON WITH DASIA
                         //                   1F5A " <reserved>
                         @"\u03A5\u0314\u0300", @"\u1F5B", // GREEK CAPITAL LETTER UPSILON WITH DASIA AND VARIA
                         //                   1F5C " <reserved>
                         @"\u03A5\u0314\u0301", @"\u1F5D", // GREEK CAPITAL LETTER UPSILON WITH DASIA AND OXIA
                         //                   1F5E " <reserved>
                         @"\u03A5\u0314\u0342", @"\u1F5F", // GREEK CAPITAL LETTER UPSILON WITH DASIA AND PERISPOMENI
                         @"\u03C9\u0313", @"\u1F60", // GREEK SMALL LETTER OMEGA WITH PSILI
                         @"\u03C9\u0314", @"\u1F61", // GREEK SMALL LETTER OMEGA WITH DASIA
                         @"\u03C9\u0313\u0300", @"\u1F62", // GREEK SMALL LETTER OMEGA WITH PSILI AND VARIA
                         @"\u03C9\u0314\u0300", @"\u1F63", // GREEK SMALL LETTER OMEGA WITH DASIA AND VARIA
                         @"\u03C9\u0313\u0301", @"\u1F64", // GREEK SMALL LETTER OMEGA WITH PSILI AND OXIA
                         @"\u03C9\u0314\u0301", @"\u1F65", // GREEK SMALL LETTER OMEGA WITH DASIA AND OXIA
                         @"\u03C9\u0313\u0342", @"\u1F66", // GREEK SMALL LETTER OMEGA WITH PSILI AND PERISPOMENI
                         @"\u03C9\u0314\u0342", @"\u1F67", // GREEK SMALL LETTER OMEGA WITH DASIA AND PERISPOMENI
                         @"\u03A9\u0313", @"\u1F68", // GREEK CAPITAL LETTER OMEGA WITH PSILI
                         @"\u03A9\u0314", @"\u1F69", // GREEK CAPITAL LETTER OMEGA WITH DASIA
                         @"\u03A9\u0313\u0300", @"\u1F6A", // GREEK CAPITAL LETTER OMEGA WITH PSILI AND VARIA
                         @"\u03A9\u0314\u0300", @"\u1F6B", // GREEK CAPITAL LETTER OMEGA WITH DASIA AND VARIA
                         @"\u03A9\u0313\u0301", @"\u1F6C", // GREEK CAPITAL LETTER OMEGA WITH PSILI AND OXIA
                         @"\u03A9\u0314\u0301", @"\u1F6D", // GREEK CAPITAL LETTER OMEGA WITH DASIA AND OXIA
                         @"\u03A9\u0313\u0342", @"\u1F6E", // GREEK CAPITAL LETTER OMEGA WITH PSILI AND PERISPOMENI
                         @"\u03A9\u0314\u0342", @"\u1F6F", // GREEK CAPITAL LETTER OMEGA WITH DASIA AND PERISPOMENI
                         @"\u03B1\u0300", @"\u1F70", // GREEK SMALL LETTER ALPHA WITH VARIA
                         @"\u03B1\u0301", @"\u1F71", // GREEK SMALL LETTER ALPHA WITH OXIA
                         @"\u03B5\u0300", @"\u1F72", // GREEK SMALL LETTER EPSILON WITH VARIA
                         @"\u03B5\u0301", @"\u1F73", // GREEK SMALL LETTER EPSILON WITH OXIA
                         @"\u03B7\u0300", @"\u1F74", // GREEK SMALL LETTER ETA WITH VARIA
                         @"\u03B7\u0301", @"\u1F75", // GREEK SMALL LETTER ETA WITH OXIA
                         @"\u03B9\u0300", @"\u1F76", // GREEK SMALL LETTER IOTA WITH VARIA
                         @"\u03B9\u0301", @"\u1F77", // GREEK SMALL LETTER IOTA WITH OXIA
                         @"\u03BF\u0300", @"\u1F78", // GREEK SMALL LETTER OMICRON WITH VARIA
                         @"\u03BF\u0301", @"\u1F79", // GREEK SMALL LETTER OMICRON WITH OXIA
                         @"\u03C5\u0300", @"\u1F7A", // GREEK SMALL LETTER UPSILON WITH VARIA
                         @"\u03C5\u0301", @"\u1F7B", // GREEK SMALL LETTER UPSILON WITH OXIA
                         @"\u03C9\u0300", @"\u1F7C", // GREEK SMALL LETTER OMEGA WITH VARIA
                         @"\u03C9\u0301", @"\u1F7D", // GREEK SMALL LETTER OMEGA WITH OXIA
                         //                   1F7E " <reserved>
                         //                   1F7F " <reserved>
                         @"\u03B1\u0313\u0345", @"\u1F80", // GREEK SMALL LETTER ALPHA WITH PSILI AND YPOGEGRAMMENI
                         @"\u03B1\u0314\u0345", @"\u1F81", // GREEK SMALL LETTER ALPHA WITH DASIA AND YPOGEGRAMMENI
                         @"\u03B1\u0313\u0300\u0345", @"\u1F82", // GREEK SMALL LETTER ALPHA WITH PSILI AND VARIA AND YPOGEGRAMMENI
                         @"\u03B1\u0314\u0300\u0345", @"\u1F83", // GREEK SMALL LETTER ALPHA WITH DASIA AND VARIA AND YPOGEGRAMMENI
                         @"\u03B1\u0313\u0301\u0345", @"\u1F84", // GREEK SMALL LETTER ALPHA WITH PSILI AND OXIA AND YPOGEGRAMMENI
                         @"\u03B1\u0314\u0301\u0345", @"\u1F85", // GREEK SMALL LETTER ALPHA WITH DASIA AND OXIA AND YPOGEGRAMMENI
                         @"\u03B1\u0313\u0342\u0345", @"\u1F86", // GREEK SMALL LETTER ALPHA WITH PSILI AND PERISPOMENI AND YPOGEGRAMMENI
                         @"\u03B1\u0314\u0342\u0345", @"\u1F87", // GREEK SMALL LETTER ALPHA WITH DASIA AND PERISPOMENI AND YPOGEGRAMMENI
                         @"\u0391\u0313\u0345", @"\u1F88", // GREEK CAPITAL LETTER ALPHA WITH PSILI AND PROSGEGRAMMENI
                         @"\u0391\u0314\u0345", @"\u1F89", // GREEK CAPITAL LETTER ALPHA WITH DASIA AND PROSGEGRAMMENI
                         @"\u0391\u0313\u0300\u0345", @"\u1F8A", // GREEK CAPITAL LETTER ALPHA WITH PSILI AND VARIA AND PROSGEGRAMMENI
                         @"\u0391\u0314\u0300\u0345", @"\u1F8B", // GREEK CAPITAL LETTER ALPHA WITH DASIA AND VARIA AND PROSGEGRAMMENI
                         @"\u0391\u0313\u0301\u0345", @"\u1F8C", // GREEK CAPITAL LETTER ALPHA WITH PSILI AND OXIA AND PROSGEGRAMMENI
                         @"\u0391\u0314\u0301\u0345", @"\u1F8D", // GREEK CAPITAL LETTER ALPHA WITH DASIA AND OXIA AND PROSGEGRAMMENI
                         @"\u0391\u0313\u0342\u0345", @"\u1F8E", // GREEK CAPITAL LETTER ALPHA WITH PSILI AND PERISPOMENI AND PROSGEGRAMMENI
                         @"\u0391\u0314\u0342\u0345", @"\u1F8F", // GREEK CAPITAL LETTER ALPHA WITH DASIA AND PERISPOMENI AND PROSGEGRAMMENI
                         @"\u03B7\u0313\u0345", @"\u1F90", // GREEK SMALL LETTER ETA WITH PSILI AND YPOGEGRAMMENI
                         @"\u03B7\u0314\u0345", @"\u1F91", // GREEK SMALL LETTER ETA WITH DASIA AND YPOGEGRAMMENI
                         @"\u03B7\u0313\u0300\u0345", @"\u1F92", // GREEK SMALL LETTER ETA WITH PSILI AND VARIA AND YPOGEGRAMMENI
                         @"\u03B7\u0314\u0300\u0345", @"\u1F93", // GREEK SMALL LETTER ETA WITH DASIA AND VARIA AND YPOGEGRAMMENI
                         @"\u03B7\u0313\u0301\u0345", @"\u1F94", // GREEK SMALL LETTER ETA WITH PSILI AND OXIA AND YPOGEGRAMMENI
                         @"\u03B7\u0314\u0301\u0345", @"\u1F95", // GREEK SMALL LETTER ETA WITH DASIA AND OXIA AND YPOGEGRAMMENI
                         @"\u03B7\u0313\u0342\u0345", @"\u1F96", // GREEK SMALL LETTER ETA WITH PSILI AND PERISPOMENI AND YPOGEGRAMMENI
                         @"\u03B7\u0314\u0342\u0345", @"\u1F97", // GREEK SMALL LETTER ETA WITH DASIA AND PERISPOMENI AND YPOGEGRAMMENI
                         @"\u0397\u0313\u0345", @"\u1F98", // GREEK CAPITAL LETTER ETA WITH PSILI AND PROSGEGRAMMENI
                         @"\u0397\u0314\u0345", @"\u1F99", // GREEK CAPITAL LETTER ETA WITH DASIA AND PROSGEGRAMMENI
                         @"\u0397\u0313\u0300\u0345", @"\u1F9A", // GREEK CAPITAL LETTER ETA WITH PSILI AND VARIA AND PROSGEGRAMMENI
                         @"\u0397\u0314\u0300\u0345", @"\u1F9B", // GREEK CAPITAL LETTER ETA WITH DASIA AND VARIA AND PROSGEGRAMMENI
                         @"\u0397\u0313\u0301\u0345", @"\u1F9C", // GREEK CAPITAL LETTER ETA WITH PSILI AND OXIA AND PROSGEGRAMMENI
                         @"\u0397\u0314\u0301\u0345", @"\u1F9D", // GREEK CAPITAL LETTER ETA WITH DASIA AND OXIA AND PROSGEGRAMMENI
                         @"\u0397\u0313\u0342\u0345", @"\u1F9E", // GREEK CAPITAL LETTER ETA WITH PSILI AND PERISPOMENI AND PROSGEGRAMMENI
                         @"\u0397\u0314\u0342\u0345", @"\u1F9F", // GREEK CAPITAL LETTER ETA WITH DASIA AND PERISPOMENI AND PROSGEGRAMMENI
                         @"\u03C9\u0313\u0345", @"\u1FA0", // GREEK SMALL LETTER OMEGA WITH PSILI AND YPOGEGRAMMENI
                         @"\u03C9\u0314\u0345", @"\u1FA1", // GREEK SMALL LETTER OMEGA WITH DASIA AND YPOGEGRAMMENI
                         @"\u03C9\u0313\u0300\u0345", @"\u1FA2", // GREEK SMALL LETTER OMEGA WITH PSILI AND VARIA AND YPOGEGRAMMENI
                         @"\u03C9\u0314\u0300\u0345", @"\u1FA3", // GREEK SMALL LETTER OMEGA WITH DASIA AND VARIA AND YPOGEGRAMMENI
                         @"\u03C9\u0313\u0301\u0345", @"\u1FA4", // GREEK SMALL LETTER OMEGA WITH PSILI AND OXIA AND YPOGEGRAMMENI
                         @"\u03C9\u0314\u0301\u0345", @"\u1FA5", // GREEK SMALL LETTER OMEGA WITH DASIA AND OXIA AND YPOGEGRAMMENI
                         @"\u03C9\u0313\u0342\u0345", @"\u1FA6", // GREEK SMALL LETTER OMEGA WITH PSILI AND PERISPOMENI AND YPOGEGRAMMENI
                         @"\u03C9\u0314\u0342\u0345", @"\u1FA7", // GREEK SMALL LETTER OMEGA WITH DASIA AND PERISPOMENI AND YPOGEGRAMMENI
                         @"\u03A9\u0313\u0345", @"\u1FA8", // GREEK CAPITAL LETTER OMEGA WITH PSILI AND PROSGEGRAMMENI
                         @"\u03A9\u0314\u0345", @"\u1FA9", // GREEK CAPITAL LETTER OMEGA WITH DASIA AND PROSGEGRAMMENI
                         @"\u03A9\u0313\u0300\u0345", @"\u1FAA", // GREEK CAPITAL LETTER OMEGA WITH PSILI AND VARIA AND PROSGEGRAMMENI
                         @"\u03A9\u0314\u0300\u0345", @"\u1FAB", // GREEK CAPITAL LETTER OMEGA WITH DASIA AND VARIA AND PROSGEGRAMMENI
                         @"\u03A9\u0313\u0301\u0345", @"\u1FAC", // GREEK CAPITAL LETTER OMEGA WITH PSILI AND OXIA AND PROSGEGRAMMENI
                         @"\u03A9\u0314\u0301\u0345", @"\u1FAD", // GREEK CAPITAL LETTER OMEGA WITH DASIA AND OXIA AND PROSGEGRAMMENI
                         @"\u03A9\u0313\u0342\u0345", @"\u1FAE", // GREEK CAPITAL LETTER OMEGA WITH PSILI AND PERISPOMENI AND PROSGEGRAMMENI
                         @"\u03A9\u0314\u0342\u0345", @"\u1FAF", // GREEK CAPITAL LETTER OMEGA WITH DASIA AND PERISPOMENI AND PROSGEGRAMMENI
                         @"\u03B1\u0306", @"\u1FB0", // GREEK SMALL LETTER ALPHA WITH VRACHY
                         @"\u03B1\u0304", @"\u1FB1", // GREEK SMALL LETTER ALPHA WITH MACRON
                         @"\u03B1\u0300\u0345", @"\u1FB2", // GREEK SMALL LETTER ALPHA WITH VARIA AND YPOGEGRAMMENI
                         @"\u03B1\u0345", @"\u1FB3", // GREEK SMALL LETTER ALPHA WITH YPOGEGRAMMENI
                         @"\u03B1\u0301\u0345", @"\u1FB4", // GREEK SMALL LETTER ALPHA WITH OXIA AND YPOGEGRAMMENI
                         //                   1FB5 " <reserved>
                         @"\u03B1\u0342", @"\u1FB6", // GREEK SMALL LETTER ALPHA WITH PERISPOMENI
                         @"\u03B1\u0342\u0345", @"\u1FB7", // GREEK SMALL LETTER ALPHA WITH PERISPOMENI AND YPOGEGRAMMENI
                         @"\u0391\u0306", @"\u1FB8", // GREEK CAPITAL LETTER ALPHA WITH VRACHY
                         @"\u0391\u0304", @"\u1FB9", // GREEK CAPITAL LETTER ALPHA WITH MACRON
                         @"\u0391\u0300", @"\u1FBA", // GREEK CAPITAL LETTER ALPHA WITH VARIA
                         //                   1FBB Ά GREEK CAPITAL LETTER ALPHA WITH OXIA ≡ 0386 Ά greek capital letter alpha with tonos
                         @"\u0391\u0345", @"\u1FBC", // GREEK CAPITAL LETTER ALPHA WITH PROSGEGRAMMENI
                         //                   1FBD ᾽ GREEK KORONIS ≈ 0020  0313 $̓
                         //                   1FBE ι GREEK PROSGEGRAMMENI ≡ 03B9 ι greek small letter iota
                         //                   1FBF ᾿ GREEK PSILI → 02BC ʼ modifier letter apostrophe ≈ 0020  0313 $̓
                         //                   1FC0 ῀ GREEK PERISPOMENI ≈ 0020  0342 $͂
                         //                   1FC1 ῁ GREEK DIALYTIKA AND PERISPOMENI ≡ 00A8 ¨ 0342 $͂
                         @"\u03B7\u0300\u0345", @"\u1FC2", // GREEK SMALL LETTER ETA WITH VARIA AND YPOGEGRAMMENI
                         @"\u03B7\u0345", @"\u1FC3", // GREEK SMALL LETTER ETA WITH YPOGEGRAMMENI
                         @"\u03B7\u0301\u0345", @"\u1FC4", // GREEK SMALL LETTER ETA WITH OXIA AND YPOGEGRAMMENI
                         //                   1FC5 " <reserved>
                         @"\u03B7\u0342", @"\u1FC6", // GREEK SMALL LETTER ETA WITH PERISPOMENI
                         @"\u03B7\u0342\u0345", @"\u1FC7", // GREEK SMALL LETTER ETA WITH PERISPOMENI AND YPOGEGRAMMENI
                         @"\u0395\u0300", @"\u1FC8", // GREEK CAPITAL LETTER EPSILON WITH VARIA
                         //                   1FC9 Έ GREEK CAPITAL LETTER EPSILON WITH OXIA ≡ 0388 Έ greek capital letter epsilon with tonos
                         @"\u0397\u0300", @"\u1FCA", // GREEK CAPITAL LETTER ETA WITH VARIA
                         //                   1FCB Ή GREEK CAPITAL LETTER ETA WITH OXIA ≡ 0389 Ή greek capital letter eta with tonos
                         @"\u0397\u0345", @"\u1FCC", // GREEK CAPITAL LETTER ETA WITH PROSGEGRAMMENI
                         //                   1FCD ῍ GREEK PSILI AND VARIA ≡ 1FBF ᾿ 0300 $ 
                         //                   1FCE ῎ GREEK PSILI AND OXIA ≡ 1FBF ᾿ 0301 $́
                         //                   1FCF ῏ GREEK PSILI AND PERISPOMENI ≡ 1FBF ᾿ 0342 $͂
                         @"\u03B9\u0306", @"\u1FD0", // GREEK SMALL LETTER IOTA WITH VRACHY
                         @"\u03B9\u0304", @"\u1FD1", // GREEK SMALL LETTER IOTA WITH MACRON
                         @"\u03B9\u0308\u0300", @"\u1FD2", // GREEK SMALL LETTER IOTA WITH DIALYTIKA AND VARIA
                         @"\u03B9\u0308\u0301", @"\u1FD3", // GREEK SMALL LETTER IOTA WITH DIALYTIKA AND OXIA
                         //                   1FD4 " <reserved>
                         //                   1FD5 " <reserved>
                         @"\u03B9\u0342", @"\u1FD6", // GREEK SMALL LETTER IOTA WITH PERISPOMENI
                         @"\u03B9\u0308\u0342", @"\u1FD7", // GREEK SMALL LETTER IOTA WITH DIALYTIKA AND PERISPOMENI
                         @"\u0399\u0306", @"\u1FD8", // GREEK CAPITAL LETTER IOTA WITH VRACHY
                         @"\u0399\u0304", @"\u1FD9", // GREEK CAPITAL LETTER IOTA WITH MACRON
                         @"\u0399\u0300", @"\u1FDA", // GREEK CAPITAL LETTER IOTA WITH VARIA
                         //                   1FDB Ί GREEK CAPITAL LETTER IOTA WITH OXIA ≡ 038A Ί greek capital letter iota with tonos
                         //                   1FDC " <reserved>
                         //                   1FDD ῝ GREEK DASIA AND VARIA ≡ 1FFE ῾ 0300 $ 
                         //                   1FDE ῞ GREEK DASIA AND OXIA ≡ 1FFE ῾ 0301 $́
                         //                   1FDF ῟ GREEK DASIA AND PERISPOMENI ≡ 1FFE ῾ 0342 $͂
                         @"\u03C5\u0306", @"\u1FE0", // GREEK SMALL LETTER UPSILON WITH VRACHY
                         @"\u03C5\u0304", @"\u1FE1", // GREEK SMALL LETTER UPSILON WITH MACRON
                         @"\u03C5\u0308\u0300", @"\u1FE2", // GREEK SMALL LETTER UPSILON WITH DIALYTIKA AND VARIA
                         @"\u03C5\u0308\u0301", @"\u1FE3", // GREEK SMALL LETTER UPSILON WITH DIALYTIKA AND OXIA
                         @"\u03C1\u0313", @"\u1FE4", // GREEK SMALL LETTER RHO WITH PSILI
                         @"\u03C1\u0314", @"\u1FE5", // GREEK SMALL LETTER RHO WITH DASIA
                         @"\u03C5\u0342", @"\u1FE6", // GREEK SMALL LETTER UPSILON WITH PERISPOMENI
                         @"\u03C5\u0308\u0342", @"\u1FE7", // GREEK SMALL LETTER UPSILON WITH DIALYTIKA AND PERISPOMENI
                         @"\u03A5\u0306", @"\u1FE8", // GREEK CAPITAL LETTER UPSILON WITH VRACHY
                         @"\u03A5\u0304", @"\u1FE9", // GREEK CAPITAL LETTER UPSILON WITH MACRON
                         @"\u03A5\u0300", @"\u1FEA", // GREEK CAPITAL LETTER UPSILON WITH VARIA
                         //                   1FEB Ύ GREEK CAPITAL LETTER UPSILON WITH OXIA ≡ 038E Ύ greek capital letter upsilon with tonos
                         @"\u03A1\u0314", @"\u1FEC", // GREEK CAPITAL LETTER RHO WITH DASIA
                         //                   1FED ῭ GREEK DIALYTIKA AND VARIA ≡ 00A8 ¨ 0300 $ 
                         //                   1FEE ΅ GREEK DIALYTIKA AND OXIA ≡ 0385 ΅ greek dialytika tonos
                         //                   1FEF ` GREEK VARIA ≡ 0060 ` grave accent
                         //                   1FF0 " <reserved>
                         //                   1FF1 " <reserved>
                         @"\u03C9\u0300\u0345", @"\u1FF2", // GREEK SMALL LETTER OMEGA WITH VARIA AND YPOGEGRAMMENI
                         @"\u03C9\u0345", @"\u1FF3", // GREEK SMALL LETTER OMEGA WITH YPOGEGRAMMENI
                         @"\u03C9\u0301\u0345", @"\u1FF4", // GREEK SMALL LETTER OMEGA WITH OXIA AND YPOGEGRAMMENI
                         //                   1FF5 " <reserved>
                         @"\u03C9\u0342", @"\u1FF6", // GREEK SMALL LETTER OMEGA WITH PERISPOMENI
                         @"\u03C9\u0342\u0345", @"\u1FF7", // GREEK SMALL LETTER OMEGA WITH PERISPOMENI AND YPOGEGRAMMENI
                         @"\u039F\u0300", @"\u1FF8", // GREEK CAPITAL LETTER OMICRON WITH VARIA
                         //                   1FF9 Ό GREEK CAPITAL LETTER OMICRON WITH OXIA ≡ 038C Ό greek capital letter omicron with tonos
                         @"\u03A9\u0300", @"\u1FFA", // GREEK CAPITAL LETTER OMEGA WITH VARIA
                         //                   1FFB Ώ GREEK CAPITAL LETTER OMEGA WITH OXIA ≡ 038F Ώ greek capital letter omega with tonos
                         @"\u03A9\u0345", @"\u1FFC", // GREEK CAPITAL LETTER OMEGA WITH PROSGEGRAMMENI
                         //                   1FFD  ́ GREEK OXIA ≡ 00B4 ´ acute accent
                         //                   1FFE ῾ GREEK DASIA → 02BD ʽ modifier letter reversed comma ≈ 0020  0314 $̔

                         nil];
    
    if (self = [super initWithName:@"Greek Normalize to Composite Characters" searchReplaceMap:map])
    {
        self.languageScriptTag = @SCRIPT_TAG_GREEK;
    }
    return self;
}

@end
