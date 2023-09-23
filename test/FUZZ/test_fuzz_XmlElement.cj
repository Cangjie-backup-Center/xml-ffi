// 3rd_party_lib:xml4cj/build/xml4cj
from xml4cj import xml4cj.*
from fuzz import fuzz.*




var flag:Int32=0
public func XmlElement1(dp:DataProvider):Int32 {

    
    try{
        XmlElement(dp.consumeString(5),dp.consumeString(5))
    }catch (e:Exception) {
        flag=-1
    }
    return flag
}

main(){

    Fuzzer(XmlElement1).startFuzz()
        return 0

}