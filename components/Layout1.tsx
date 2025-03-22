import { t } from "@/locales/en";
import { Home, Shapes, Trophy, ZapIcon } from "lucide-react";

const Layout1 = () => {
  return (
    <div className="flex flex-wrap justify-evenly min-w-full min-h-screen bg-card py-6">
      <div className="flex flex-col w-full sm:w-1/4">
        <div className="h-2/3 bg-zinc-400 mb-2 flex items-center justify-center text-white text-xl font-bold">
          Contact Info
        </div>
        <div className="h-1/3 bg-zinc-400 flex items-center justify-center text-white text-xl font-bold">
          Activation Button
        </div>
      </div>
      <div className="w-full sm:w-1/3 min-h-2xl bg-zinc-400 flex items-center justify-center text-white text-2xl font-bold">
        Dashboard
      </div>
      <div className="flex flex-col w-full sm:w-1/4">
        <div className="h-1/2 bg-zinc-400 mb-2 flex items-center justify-center text-white text-xl font-bold">
          Map
        </div>
        <div className="grid grid-cols-2 gap-2 h-1/2">
          <div className="bg-zinc-400 flex flex-col items-center justify-center p-4 text-white">
            <Home size={30} />
            <p>City</p>
          </div>
          <div className="bg-zinc-400 flex flex-col items-center justify-center p-4 text-white">
            <Trophy size={30} />
            <p>{t.country}</p>
          </div>
          <div className="bg-zinc-400 flex flex-col items-center justify-center p-4 text-white">
            <Shapes size={30} />
            <p>State</p>
          </div>
          <div className="bg-zinc-400 flex flex-col items-center justify-center p-4 text-white">
            <ZapIcon size={30} />
            <p>Zip Code</p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Layout1;
