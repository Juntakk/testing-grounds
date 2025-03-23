import Link from "next/link";
import "@/app/globals.css";
export default function Home() {
  return (
    <div>
      <Link className="w-screen flex justify-center py-10" href={"/tests/game"}>
        Random Game
      </Link>
      <Link
        className="w-screen flex justify-center py-10"
        href={"/tests/datatable"}
      >
        Data Table Demo
      </Link>
      <Link
        className="w-screen flex justify-center py-10"
        href={"/tests/layouts"}
      >
        Layouts
      </Link>
      <Link
        className="w-screen flex justify-center py-10"
        href={"/tests/timer"}
      >
        Timer
      </Link>
      <Link
        className="w-screen flex justify-center py-10"
        href={"/tests/timer"}
      >
        Timer
      </Link>
    </div>
  );
}
