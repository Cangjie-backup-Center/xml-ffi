// 3rd_party_lib:xml4cj/build/xml4cj
from xml4cj import xml4cj.*
from fuzz import fuzz.*




var flag:Int32=0
public func XmlException1(dp:DataProvider):Int32 {

    
    try{
        XmlException(dp.consumeString(5))
    }catch (e:Exception) {
        flag=-1
    }
    return flag
}

main(){

    Fuzzer(XmlException1).startFuzz()
        return 0

}