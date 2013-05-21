//
//  SupressPerformSelectorMemoryWarnings.h
//  EnumeratorKit
//
//  Created by Adam Sharp on 14/05/13.
//  Copyright (c) 2013 Adam Sharp. All rights reserved.
//

#ifndef RFEnumerable_SupressPerformSelectorMemoryWarnings_h
#define RFEnumerable_SupressPerformSelectorMemoryWarnings_h

#define SuppressPerformSelectorLeakWarning(Stuff) \
        do { \
            _Pragma("clang diagnostic push") \
            _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
                Stuff; \
            _Pragma("clang diagnostic pop") \
        } while (0)

#endif
